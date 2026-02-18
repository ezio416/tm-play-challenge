class Map {
    string name;
    string path;

    Map(const string&in path) {
        this.path = path;
    }

    Map(CGameCtnChallengeInfo@ map) {
        name = map.Name;
        path = map.FileName;
    }

    void Play() {
        startnew(CoroutineFunc(PlayAsync));
    }

    void PlayAsync() {
        if (path.Length == 0) {
            NotifyError("can't play map: empty path");
            return;
        }

        if (name.Length > 0) {
            trace("loading map " + name + " from path " + path);
        } else {
            trace("loading map from path " + path);
        }

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
