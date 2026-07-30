/// Sandbox and approval preset for a session.
enum CodexAgentMode {
  /// Read operations are allowed; edits and commands require approval.
  readOnly(
    id: 'read-only',
    label: 'Read-only',
    description: 'Requires approval to edit files and run commands.',
    approvalPolicy: 'on-request',
    sandboxType: 'readOnly',
  ),

  /// Work inside the selected workspace.
  workspaceWrite(
    id: 'agent',
    label: 'Agent',
    description: 'Read and edit workspace files, and run commands.',
    approvalPolicy: 'on-request',
    sandboxType: 'workspaceWrite',
  ),

  /// Unrestricted process and filesystem access.
  fullAccess(
    id: 'agent-full-access',
    label: 'Agent (full access)',
    description: 'Allow filesystem and network access without approval.',
    approvalPolicy: 'never',
    sandboxType: 'dangerFullAccess',
  );

  const CodexAgentMode({
    required this.id,
    required this.label,
    required this.description,
    required this.approvalPolicy,
    required this.sandboxType,
  });

  /// Stable configuration id.
  final String id;

  /// Human-readable label.
  final String label;

  /// Human-readable description.
  final String description;

  /// App-server approval policy.
  final String approvalPolicy;

  /// App-server sandbox variant.
  final String sandboxType;

  /// Finds a mode by configuration id.
  static CodexAgentMode? tryParse(String value) {
    for (final mode in values) {
      if (mode.id == value) {
        return mode;
      }
    }
    return null;
  }
}

/// Collaboration behavior for subsequent turns.
enum CodexCollaborationMode {
  /// Collaborate and act directly.
  standard('default', 'Default'),

  /// Plan before making changes.
  plan('plan', 'Plan');

  const CodexCollaborationMode(this.id, this.label);

  /// Stable configuration id.
  final String id;

  /// Human-readable label.
  final String label;

  /// Finds a collaboration mode by id.
  static CodexCollaborationMode? tryParse(String value) {
    for (final mode in values) {
      if (mode.id == value) {
        return mode;
      }
    }
    return null;
  }
}
