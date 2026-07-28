using System;
using System.Diagnostics;
using System.IO;
using System.ServiceProcess;
using System.Threading;

namespace Dideban.WindowsService
{
    internal sealed class DidebanService : ServiceBase
    {
        private readonly string appDir;
        private readonly string dataDir;
        private Process child;
        private readonly object sync = new object();

        public DidebanService(string appDir, string dataDir)
        {
            ServiceName = "Dideban";
            CanStop = true;
            CanShutdown = true;
            AutoLog = true;
            this.appDir = Path.GetFullPath(appDir);
            this.dataDir = Path.GetFullPath(dataDir);
        }

        protected override void OnStart(string[] args)
        {
            Directory.CreateDirectory(Path.Combine(dataDir, "logs"));
            StartChild();
        }

        protected override void OnStop()
        {
            StopChild();
        }

        protected override void OnShutdown()
        {
            StopChild();
            base.OnShutdown();
        }

        private void StartChild()
        {
            lock (sync)
            {
                if (child != null && !child.HasExited) return;

                string nodeExe = ResolveNodeExecutable(appDir);
                string cameraJs = Path.Combine(appDir, "camera.js");
                if (!File.Exists(cameraJs)) throw new FileNotFoundException("camera.js was not found.", cameraJs);

                string logPath = Path.Combine(dataDir, "logs", "service.log");
                var startInfo = new ProcessStartInfo
                {
                    FileName = nodeExe,
                    Arguments = "\"" + cameraJs + "\"",
                    WorkingDirectory = appDir,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                };
                startInfo.EnvironmentVariables["DIDEBAN_APP_DIR"] = appDir;
                startInfo.EnvironmentVariables["DIDEBAN_DATA_DIR"] = dataDir;
                startInfo.EnvironmentVariables["NODE_ENV"] = "production";

                child = new Process { StartInfo = startInfo, EnableRaisingEvents = true };
                child.OutputDataReceived += (s, e) => AppendLine(logPath, e.Data);
                child.ErrorDataReceived += (s, e) => AppendLine(logPath, e.Data);
                child.Exited += (s, e) => AppendLine(logPath, "Dideban Node process exited with code " + child.ExitCode + ".");

                if (!child.Start()) throw new InvalidOperationException("Could not start the Dideban Node process.");
                child.BeginOutputReadLine();
                child.BeginErrorReadLine();
                AppendLine(logPath, "Dideban service started Node process PID " + child.Id + ".");
            }
        }

        private void StopChild()
        {
            lock (sync)
            {
                if (child == null) return;
                try
                {
                    if (!child.HasExited)
                    {
                        using (var killer = Process.Start(new ProcessStartInfo
                        {
                            FileName = Path.Combine(Environment.SystemDirectory, "taskkill.exe"),
                            Arguments = "/PID " + child.Id + " /T /F",
                            UseShellExecute = false,
                            CreateNoWindow = true
                        }))
                        {
                            if (killer != null) killer.WaitForExit(15000);
                        }
                        child.WaitForExit(5000);
                    }
                }
                catch { }
                finally
                {
                    child.Dispose();
                    child = null;
                }
            }
        }


        private static string ResolveNodeExecutable(string appDir)
        {
            string configured = Environment.GetEnvironmentVariable("DIDEBAN_NODE_EXE");
            if (!String.IsNullOrWhiteSpace(configured) && File.Exists(configured))
                return Path.GetFullPath(configured);

            string bundled = Path.Combine(appDir, "runtime", "node.exe");
            if (File.Exists(bundled)) return bundled;

            string local = Path.Combine(appDir, "node.exe");
            if (File.Exists(local)) return local;

            string pathValue = Environment.GetEnvironmentVariable("PATH") ?? String.Empty;
            foreach (string rawDir in pathValue.Split(Path.PathSeparator))
            {
                string dir = rawDir.Trim().Trim('"');
                if (String.IsNullOrWhiteSpace(dir)) continue;
                try
                {
                    string candidate = Path.Combine(dir, "node.exe");
                    if (File.Exists(candidate)) return candidate;
                }
                catch { }
            }

            throw new FileNotFoundException(
                "Node.js runtime was not found. Expected app\runtime\node.exe or node.exe in PATH. " +
                "For development, install Node.js or set DIDEBAN_NODE_EXE."
            );
        }

        private static void AppendLine(string path, string line)
        {
            if (String.IsNullOrEmpty(line)) return;
            try
            {
                File.AppendAllText(path, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " " + line + Environment.NewLine);
            }
            catch { }
        }

        private static string GetArg(string[] args, string name, string fallback)
        {
            for (int i = 0; i < args.Length - 1; i++)
                if (String.Equals(args[i], name, StringComparison.OrdinalIgnoreCase)) return args[i + 1];
            return fallback;
        }

        public static int Main(string[] args)
        {
            string appDir = GetArg(args, "--appdir", AppDomain.CurrentDomain.BaseDirectory);
            string dataDir = GetArg(args, "--datadir", Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "Dideban"));
            bool console = Array.Exists(args, a => String.Equals(a, "--console", StringComparison.OrdinalIgnoreCase));

            if (console)
            {
                var service = new DidebanService(appDir, dataDir);
                service.OnStart(new string[0]);
                Console.WriteLine("Dideban is running in console mode. Press Ctrl+C to stop.");
                var quit = new ManualResetEvent(false);
                Console.CancelKeyPress += (s, e) => { e.Cancel = true; quit.Set(); };
                quit.WaitOne();
                service.OnStop();
                return 0;
            }

            ServiceBase.Run(new DidebanService(appDir, dataDir));
            return 0;
        }
    }
}
