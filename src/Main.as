const string  pluginColor = "\\$88F";
const string  pluginIcon  = Icons::ClockO;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

Map@[] maps;

void Main() {
    auto App = cast<CTrackMania>(GetApp());

    while (App.ChallengeInfos.Length < 200) {
        yield();
    }

    for (uint i = 0; i < App.ChallengeInfos.Length; i++) {
        CGameCtnChallengeInfo@ map = App.ChallengeInfos[i];
        if (map !is null && map.MapUid != "" && !map.Name.Contains("VR")) {
            maps.InsertLast(Map(map));
        }
    }
}

void Render() {
    if (false
        or !S_Window
        or (true
            and S_HideWithGame
            and !UI::IsGameUIVisible()
        )
        or (true
            and S_HideWithOP
            and !UI::IsOverlayShown()
        )
    ) {
        return;
    }

    if (UI::Begin(
        pluginTitle,
        S_Window,
        UI::GetDefaultWindowFlags() | UI::WindowFlags::AlwaysAutoResize
    )) {
        RenderWindow();
    }

    UI::End();
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Window)) {
        S_Window = !S_Window;
    }
}

void RenderWindow() {
    for (uint i = 0; i < maps.Length; i++) {
        Map@ map = maps[i];

        if (i % 10 != 0) {
            UI::SameLine();
        }

        if (i < 40) {  // white
            UI::PushStyleColor(UI::Col::Button, vec4(1.0f));
            UI::PushStyleColor(UI::Col::Text, vec4(vec3(), 1.0f));
        } else if (i < 80) {  // green
            UI::PushStyleColor(UI::Col::Button, vec4(0.0f, 0.8f, 0.3f, 1.0f));
        } else if (i < 120) {  // blue
            UI::PushStyleColor(UI::Col::Button, vec4(0.0f, 0.3f, 0.8f, 1.0f));
        } else if (i < 160) {  // red
            UI::PushStyleColor(UI::Col::Button, vec4(0.8f, 0.0f, 0.0f, 1.0f));
        } else {  // black
            UI::PushStyleColor(UI::Col::Button, vec4(vec3(0.2f), 1.0f));
        }

        if (UI::Button("#" + map.name)) {
            map.Play();
        }

        UI::PopStyleColor(i < 40 ? 2 : 1);
    }
}
