#if UNITY_EDITOR

using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using Debug = UnityEngine.Debug;

public class PlatformMenu
{
    [MenuItem("Platform/Build Open Scene(s) for Linux")]
    static void BuildAndUploadLinuxServer()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var openScenes = OpenScenes().ToArray();
        var scenes = openScenes.Select(s => s.path).ToArray();
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = scenes,
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneLinux64,
            locationPathName = $@"Build\Linux\Kasteroids{openScenes[0].name}.x86_64",
            options = BuildOptions.EnableHeadlessMode | BuildOptions.ShowBuiltPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        //Process.Start(@"Build\Linux\UploadToETdoFresh.cmd");
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build and Run Open Scene(s) [Windows Headless]")]
    static void BuildAndRunOpenScenesWindowsHeadless()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var openScenes = OpenScenes().ToArray();
        var scenes = openScenes.Select(s => s.path).ToArray();
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = scenes,
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneWindows64,
            locationPathName = $@"Build\WindowsServerMode\Kasteroirds{openScenes[0].name}.exe",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development | BuildOptions.EnableHeadlessMode
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build and Run Open Scenes [Windows]")]
    static void BuildAndRunOpenScenesWindows()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var openScenes = OpenScenes().ToArray();
        var scenes = openScenes.Select(s => s.path).ToArray();
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = scenes,
            targetGroup = BuildTargetGroup.Standalone,
            target = BuildTarget.StandaloneWindows64,
            locationPathName = $@"Build\Windows\Kasteroids{openScenes[0].name}.exe",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }

    [MenuItem("Platform/Build and Run Open Scenes [WebGL]")]
    static void BuildAndRunOpenScenesWebGL()
    {
        var previousTarget = EditorUserBuildSettings.activeBuildTarget;
        var previousTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
        var buildPlayerOptions = new BuildPlayerOptions
        {
            scenes = OpenScenes().Select(s => s.path).ToArray(),
            targetGroup = BuildTargetGroup.WebGL,
            target = BuildTarget.WebGL,
            locationPathName = @"Build\WebGL",
            options = BuildOptions.AutoRunPlayer | BuildOptions.Development
        };
        BuildPipeline.BuildPlayer(buildPlayerOptions);
        EditorUserBuildSettings.SwitchActiveBuildTarget(previousTargetGroup, previousTarget);
    }
    
    public static IEnumerable<Scene> OpenScenes()
    {
        for (int i = 0; i < SceneManager.sceneCount; i++)
            yield return SceneManager.GetSceneAt(i);
    }
}

#endif