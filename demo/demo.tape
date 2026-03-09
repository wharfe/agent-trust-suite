# Agent Trust Suite — Demo Screencast
# Generates a GIF showing the trust lifecycle: contract → observation → evidence
# Run from demo/fixtures/: vhs ../demo.tape

Output "../demo.gif"

Require agent-trust

Set Shell "bash"
Set FontSize 15
Set Width 1200
Set Height 700
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 30ms

# Title pause
Sleep 1s

# === Step 1: Demo command (full lifecycle) ===
Type "# Agent Trust Suite — Trust Lifecycle Demo"
Enter
Sleep 500ms
Type "agent-trust demo"
Enter
Sleep 8s

# === Step 2: Inspect a contract ===
Type "# Inspect a contract definition"
Enter
Sleep 500ms
Type "agent-trust inspect demo-contract.yaml"
Enter
Sleep 4s

# === Step 3: Inspect a suspicious message ===
Type "# Inspect a poisoned message envelope"
Enter
Sleep 500ms
Type "agent-trust inspect msg-3-violation.json"
Enter
Sleep 4s

# Final pause
Sleep 2s
