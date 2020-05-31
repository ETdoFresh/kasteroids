#if UNITY_EDITOR

using System.IO;
using UnityEditor;

public class PlatformMenu
{
    [MenuItem("Platform/Build Server Scene for Linux")]
    static void BuildServerSceneLinux()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = new[] {EditorBuildSettings.scenes[1].path},
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneLinux64,
            locationPathName = $@"Build\Linux\KasteroidsServer.x86_64",
            options = BuildOptions.EnableHeadlessMode | BuildOptions.ShowBuiltPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        
        //Process.Start(@"Build\Linux\UploadToETdoFresh.cmd");
        
        // Copy Dockerfile folder to Build
        var sourceDirectory = @".\DockerFile\";
        var targetDirectory = @".\Build\Linux\";
        foreach (var file in Directory.GetFiles(sourceDirectory))
            File.Copy(file, Path.Combine(targetDirectory, Path.GetFileName(file)), true);
        
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build Server Scene for Windows Server Mode")]
    static void BuildAndRunServerSceneWindowsServerMode()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = new[] {EditorBuildSettings.scenes[1].path},
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneWindows64,
            locationPathName = $@"Build\WindowsServer\KasteroidsServer.exe",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development | BuildOptions.EnableHeadlessMode
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build and Run Server Scene for Windows GUI")]
    static void BuildAndRunServerSceneWindowsGUI()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = new[] {EditorBuildSettings.scenes[1].path},
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneWindows64,
            locationPathName = $@"Build\WindowsServerGUI\KasteroidsServer.exe",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build and Run Client Scene for Windows GUI")]
    static void BuildAndRunClientSceneWindowsGUI()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = new[] {EditorBuildSettings.scenes[2].path},
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneWindows64,
            locationPathName = $@"Build\WindowsClient\KasteroidsClient.exe",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build and Run Client Scene for WebGL")]
    static void BuildAndRunClientSceneWebGL()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = new[] {EditorBuildSettings.scenes[2].path},
            targetGroup = BuildTargetGroup.WebGL,
            target = BuildTarget.WebGL,
            locationPathName = @"Build\WebGL",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }
}

#endif