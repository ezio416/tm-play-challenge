const string  pluginColor = "\\$0F0";
const string  pluginIcon  = Icons::Play;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

bool       loaded = false;
dictionary maps;
dictionary mapsVRCanyon;
dictionary mapsVRLagoon;
dictionary mapsVRStadium;
dictionary mapsVRValley;

void Main() {
    LoadMapsAsync();
}

void OnDestroyed() {
    ClearMaps();
}

void OnDisabled() {
    ClearMaps();
}

void OnEnabled() {
    LoadMapsAsync();
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

    const int flags = UI::GetDefaultWindowFlags()
        | UI::WindowFlags::AlwaysAutoResize
        | UI::WindowFlags::NoFocusOnAppearing
    ;

    if (UI::Begin(pluginTitle, S_Window, flags)) {
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
