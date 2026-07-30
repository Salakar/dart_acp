import 'dart:async';

import 'elicitation.dart';
import 'json.dart';

/// How the CLI evaluates tool permissions for a session.
enum PermissionMode {
  /// Apply configured rules and request approval when needed.
  standard('default'),

  /// Automatically approve file edits.
  acceptEdits('acceptEdits'),

  /// Permit planning but prevent execution.
  plan('plan'),

  /// Bypass permission prompts except explicit deny rules.
  bypassPermissions('bypassPermissions'),

  /// Deny calls that are not already approved.
  dontAsk('dontAsk'),

  /// Ask a model classifier to approve or deny each call.
  auto('auto');

  const PermissionMode(this.wireValue);

  /// Value accepted by the CLI.
  final String wireValue;

  /// Decodes a CLI permission mode.
  static PermissionMode fromWire(String value) => values.firstWhere(
    (mode) => mode.wireValue == value,
    orElse: () => throw FormatException('Unknown permission mode: $value'),
  );
}

/// Behavior applied by a permission rule update.
enum PermissionBehavior {
  /// Permit matching tool calls.
  allow('allow'),

  /// Reject matching tool calls.
  deny('deny'),

  /// Request a runtime permission decision.
  ask('ask');

  const PermissionBehavior(this.wireValue);

  /// Control-protocol value.
  final String wireValue;

  static PermissionBehavior _fromWire(String value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => throw FormatException('Unknown permission behavior: $value'),
  );
}

/// Persistence destination for a permission update.
enum PermissionUpdateDestination {
  /// User-wide settings.
  userSettings('userSettings'),

  /// Versioned project settings.
  projectSettings('projectSettings'),

  /// Unversioned project-local settings.
  localSettings('localSettings'),

  /// The current in-memory session.
  session('session'),

  /// Permission supplied directly through a CLI argument.
  cliArgument('cliArg');

  const PermissionUpdateDestination(this.wireValue);

  /// Control-protocol value.
  final String wireValue;

  static PermissionUpdateDestination _fromWire(String value) =>
      values.firstWhere(
        (item) => item.wireValue == value,
        orElse: () =>
            throw FormatException('Unknown permission destination: $value'),
      );
}

/// Classification of a host permission decision for telemetry.
enum PermissionDecisionClassification {
  /// The user allowed this invocation only.
  userTemporary('user_temporary'),

  /// The user chose a persistent allow decision.
  userPermanent('user_permanent'),

  /// The user rejected the invocation.
  userReject('user_reject');

  const PermissionDecisionClassification(this.wireValue);

  /// Control-protocol value.
  final String wireValue;
}

/// Ask rule that forced a permission prompt while preserving a richer reason.
final class MatchedAskRule {
  /// Creates a matched ask rule.
  const MatchedAskRule({
    required this.source,
    required this.toolName,
    this.ruleContent,
  });

  /// Settings source that supplied the rule.
  final String source;

  /// Tool matched by the rule.
  final String toolName;

  /// Optional rule expression.
  final String? ruleContent;
}

/// A tool name and optional rule expression.
final class PermissionRule {
  /// Creates an immutable permission rule.
  const PermissionRule({required this.toolName, this.ruleContent})
    : assert(toolName != '');

  /// Tool to which this rule applies.
  final String toolName;

  /// Optional tool-specific matcher expression.
  final String? ruleContent;

  JsonMap _toJson() => {'toolName': toolName, 'ruleContent': ruleContent};

  static PermissionRule _fromJson(JsonMap json) => PermissionRule(
    toolName: json['toolName']! as String,
    ruleContent: json['ruleContent'] as String?,
  );
}

/// A typed mutation to the CLI permission configuration.
sealed class PermissionUpdate {
  const PermissionUpdate({this.destination});

  /// Destination in which the update should be stored.
  final PermissionUpdateDestination? destination;

  /// Encodes this update for the control protocol.
  JsonMap toJson();

  /// Decodes an update suggested by the CLI.
  static PermissionUpdate fromJson(JsonMap json) {
    final destinationValue = json['destination'];
    final destination = destinationValue is String
        ? PermissionUpdateDestination._fromWire(destinationValue)
        : null;
    final type = json['type'];
    if (type is! String) {
      throw const FormatException('Permission update type must be a string');
    }
    if (type == 'setMode') {
      final mode = json['mode'];
      if (mode is! String) {
        throw const FormatException('setMode update requires mode');
      }
      return SetPermissionMode(
        mode: PermissionMode.fromWire(mode),
        destination: destination,
      );
    }
    if (type == 'addDirectories' || type == 'removeDirectories') {
      final directories = json['directories'];
      if (directories is! List<Object?> ||
          directories.any((item) => item is! String)) {
        throw FormatException('$type update requires string directories');
      }
      final values = directories.cast<String>();
      return type == 'addDirectories'
          ? AddPermissionDirectories(
              directories: values,
              destination: destination,
            )
          : RemovePermissionDirectories(
              directories: values,
              destination: destination,
            );
    }
    if (type == 'addRules' || type == 'replaceRules' || type == 'removeRules') {
      final rawRules = json['rules'];
      final rawBehavior = json['behavior'];
      if (rawRules is! List<Object?> ||
          rawRules.any((item) => item is! Map<Object?, Object?>) ||
          rawBehavior is! String) {
        throw FormatException('$type update requires rules and behavior');
      }
      final rules = rawRules
          .map((item) => PermissionRule._fromJson(asJsonMap(item, 'rule')))
          .toList(growable: false);
      final behavior = PermissionBehavior._fromWire(rawBehavior);
      return switch (type) {
        'addRules' => AddPermissionRules(
          rules: rules,
          behavior: behavior,
          destination: destination,
        ),
        'replaceRules' => ReplacePermissionRules(
          rules: rules,
          behavior: behavior,
          destination: destination,
        ),
        _ => RemovePermissionRules(
          rules: rules,
          behavior: behavior,
          destination: destination,
        ),
      };
    }
    throw FormatException('Unknown permission update type: $type');
  }

  /// Encodes fields shared by every permission update.
  JsonMap baseJson(String type) => {
    'type': type,
    if (destination != null) 'destination': destination!.wireValue,
  };
}

abstract base class _RulePermissionUpdate extends PermissionUpdate {
  _RulePermissionUpdate({
    required List<PermissionRule> rules,
    required this.behavior,
    super.destination,
  }) : rules = List<PermissionRule>.unmodifiable(rules) {
    if (rules.isEmpty) {
      throw ArgumentError.value(rules, 'rules', 'must not be empty');
    }
  }

  final List<PermissionRule> rules;
  final PermissionBehavior behavior;

  JsonMap rulesJson(String type) => {
    ...baseJson(type),
    'rules': rules.map((rule) => rule._toJson()).toList(growable: false),
    'behavior': behavior.wireValue,
  };
}

/// Adds permission rules without replacing existing rules.
final class AddPermissionRules extends _RulePermissionUpdate {
  /// Creates an add-rules update.
  AddPermissionRules({
    required super.rules,
    required super.behavior,
    super.destination,
  });

  @override
  JsonMap toJson() => rulesJson('addRules');
}

/// Replaces the rules for a behavior.
final class ReplacePermissionRules extends _RulePermissionUpdate {
  /// Creates a replace-rules update.
  ReplacePermissionRules({
    required super.rules,
    required super.behavior,
    super.destination,
  });

  @override
  JsonMap toJson() => rulesJson('replaceRules');
}

/// Removes matching permission rules.
final class RemovePermissionRules extends _RulePermissionUpdate {
  /// Creates a remove-rules update.
  RemovePermissionRules({
    required super.rules,
    required super.behavior,
    super.destination,
  });

  @override
  JsonMap toJson() => rulesJson('removeRules');
}

/// Changes the permission mode.
final class SetPermissionMode extends PermissionUpdate {
  /// Creates a mode update.
  const SetPermissionMode({required this.mode, super.destination});

  /// New permission mode.
  final PermissionMode mode;

  @override
  JsonMap toJson() => {...baseJson('setMode'), 'mode': mode.wireValue};
}

abstract base class _DirectoryPermissionUpdate extends PermissionUpdate {
  _DirectoryPermissionUpdate({
    required List<String> directories,
    super.destination,
  }) : directories = List<String>.unmodifiable(directories) {
    if (directories.isEmpty || directories.any((path) => path.isEmpty)) {
      throw ArgumentError.value(
        directories,
        'directories',
        'must contain non-empty paths',
      );
    }
  }

  final List<String> directories;

  JsonMap directoriesJson(String type) => {
    ...baseJson(type),
    'directories': directories,
  };
}

/// Adds accessible directories.
final class AddPermissionDirectories extends _DirectoryPermissionUpdate {
  /// Creates an add-directories update.
  AddPermissionDirectories({required super.directories, super.destination});

  @override
  JsonMap toJson() => directoriesJson('addDirectories');
}

/// Removes accessible directories.
final class RemovePermissionDirectories extends _DirectoryPermissionUpdate {
  /// Creates a remove-directories update.
  RemovePermissionDirectories({required super.directories, super.destination});

  @override
  JsonMap toJson() => directoriesJson('removeDirectories');
}

/// Additional information supplied to a permission callback.
final class ToolPermissionContext {
  /// Creates permission callback context.
  ToolPermissionContext({
    List<PermissionUpdate> suggestions = const [],
    this.toolUseId,
    this.requestId,
    this.agentId,
    this.blockedPath,
    this.decisionReason,
    this.decisionReasonType,
    this.classifierApprovable,
    this.suppressAlwaysAllowRule,
    this.matchedAskRule,
    this.requiresUserInteraction,
    this.title,
    this.displayName,
    this.description,
    this.cancellation,
  }) : suggestions = List<PermissionUpdate>.unmodifiable(suggestions);

  /// Permission updates proposed by the CLI.
  final List<PermissionUpdate> suggestions;

  /// Identifier of the tool invocation.
  final String? toolUseId;

  /// Incoming control request identifier.
  final String? requestId;

  /// Subagent identifier when the invocation belongs to a subagent.
  final String? agentId;

  /// Path that triggered the request, when applicable.
  final String? blockedPath;

  /// Reason a previous rule or hook requested a decision.
  final String? decisionReason;

  /// Structured reason discriminator for the permission prompt.
  final String? decisionReasonType;

  /// Whether every safety check may be classifier-approved.
  final bool? classifierApprovable;

  /// Whether a persistent allow affordance must be hidden.
  final bool? suppressAlwaysAllowRule;

  /// Ask rule that forced this prompt, when reported separately.
  final MatchedAskRule? matchedAskRule;

  /// Whether the tool's own UI must collect the decision.
  final bool? requiresUserInteraction;

  /// Full prompt text suitable for a user-facing dialog.
  final String? title;

  /// Compact name suitable for a button or list.
  final String? displayName;

  /// Human-readable detail for the permission UI.
  final String? description;

  /// Cooperative cancellation signal for this permission interaction.
  ///
  /// This is present for runtime-originated callbacks and absent when a
  /// context is constructed directly by an SDK consumer.
  final ControlCallbackCancellation? cancellation;
}

/// Result returned by a [CanUseTool] callback.
sealed class PermissionResult {
  const PermissionResult();
}

/// Allows a tool call, optionally changing its input or persistent rules.
final class PermissionAllowed extends PermissionResult {
  /// Creates an allow result.
  PermissionAllowed({
    JsonMap? updatedInput,
    List<PermissionUpdate>? updatedPermissions,
    this.decisionClassification,
  }) : updatedInput = updatedInput == null
           ? null
           : immutableJsonMap(updatedInput),
       updatedPermissions = updatedPermissions == null
           ? null
           : List<PermissionUpdate>.unmodifiable(updatedPermissions);

  /// Replacement tool input, or `null` to retain the original input.
  final JsonMap? updatedInput;

  /// Permission updates to apply after allowing the call.
  final List<PermissionUpdate>? updatedPermissions;

  /// How this decision was reached.
  final PermissionDecisionClassification? decisionClassification;
}

/// Denies a tool call.
final class PermissionDenied extends PermissionResult {
  /// Creates a denial result.
  const PermissionDenied({
    required this.message,
    this.shouldInterrupt = false,
    this.decisionClassification,
  });

  /// Explanation delivered to the agent.
  final String message;

  /// Whether the current run should also be interrupted.
  final bool shouldInterrupt;

  /// How this decision was reached.
  final PermissionDecisionClassification? decisionClassification;
}

/// Decides a tool call that reached the CLI's interactive permission step.
typedef CanUseTool =
    Future<PermissionResult?> Function(
      String toolName,
      JsonMap input,
      ToolPermissionContext context,
    );
