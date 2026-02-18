class Map {
    string name;
    string path;

    Map(CGameCtnChallengeInfo@ map) {
        name = map.Name;
        path = map.FileName;
    }

    void Play() {
        startnew(CoroutineFunc(PlayAsync));
    }

    void PlayAsync() {
        if (false
            or name.Length == 0
            or path.Length == 0
        ) {
            error("empty name or path, can't play map");
            return;
        }

        print("loading map " + name + " from path " + path);

        auto App = cast<CTrackMania>(GetApp());

        App.BackToMainMenu();

        while (!App.ManiaTitleFlowScriptAPI.IsReady) {
            yield();
        }

        App.ManiaTitleFlowScriptAPI.PlayMap(path, "TMC_CampaignSolo", "");

        while (!App.ManiaTitleFlowScriptAPI.IsReady) {
            yield();
        }
    }
}
