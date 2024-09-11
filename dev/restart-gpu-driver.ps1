# Add the necessary .NET assembly for using Windows API functions
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    // Import the keybd_event function from user32.dll
    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, uint dwExtraInfo);

    // Constants for the virtual key codes and flags
    const byte VK_LWIN = 0x5B; // Left Windows key
    const byte VK_CONTROL = 0x11; // Control key
    const byte VK_SHIFT = 0x10; // Shift key
    const byte VK_B = 0x42; // B key
    const uint KEYEVENTF_KEYDOWN = 0x0000; // Key down flag
    const uint KEYEVENTF_KEYUP = 0x0002; // Key up flag

    public static void SendWinCtrlShiftB() {
        // Simulate key presses: Win + Ctrl + Shift + B
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYDOWN, 0);
        keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYDOWN, 0);
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYDOWN, 0);
        keybd_event(VK_B, 0, KEYEVENTF_KEYDOWN, 0);

        // Simulate key releases: B, Shift, Ctrl, Win
        keybd_event(VK_B, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
    }
}
"@

# Call the function to send Windows + Ctrl + Shift + B
[Keyboard]::SendWinCtrlShiftB()
