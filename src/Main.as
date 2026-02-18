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

const PlayChallenge::Environment[] envis = {
    PlayChallenge::Environment::Canyon,
    PlayChallenge::Environment::Valley,
    PlayChallenge::Environment::Lagoon,
    PlayChallenge::Environment::Stadium
};

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
        or !loaded
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
    const bool demo = Demo();

    const vec2 pre = UI::GetCursorPos();
    UI::Dummy(vec2(UI::GetScale() * 482.0f, 0.0f));
    UI::SetCursorPos(pre);

    UI::PushFont(UI::Font::DefaultBold);

    if (UI::TreeNode("Campaign", UI::TreeNodeFlags::Framed)) {
        for (uint i = 1; i <= 200; i++) {
            if ((i - 1) % 10 > 0) {
                UI::SameLine();
            }

            if (i <= 40) {  // white
                UI::PushStyleColor(UI::Col::Button, vec4(1.0f));
                UI::PushStyleColor(UI::Col::Text, vec4(vec3(), 1.0f));
            } else if (i <= 80) {  // green
                UI::PushStyleColor(UI::Col::Button, vec4(0.0f, 0.8f, 0.3f, 1.0f));
            } else if (i <= 120) {  // blue
                UI::PushStyleColor(UI::Col::Button, vec4(0.0f, 0.3f, 0.8f, 1.0f));
            } else if (i <= 160) {  // red
                UI::PushStyleColor(UI::Col::Button, vec4(0.8f, 0.0f, 0.0f, 1.0f));
            } else {  // black
                UI::PushStyleColor(UI::Col::Button, vec4(vec3(0.2f), 1.0f));
            }

            UI::BeginDisabled(true
                and demo
                and i > 5
            );

            if (UI::Button(Text::Format("%03d", i))) {
                PlayChallenge::PlayCampaignChallenge(i);
            }

            UI::EndDisabled();
            UI::PopStyleColor(i <= 40 ? 2 : 1);
        }

        UI::TreePop();
    }

    if (UI::TreeNode("VR", UI::TreeNodeFlags::Framed)) {
        UI::BeginDisabled(demo);

        PlayChallenge::Environment envi;
        for (uint i = 0; i < envis.Length; i++) {
            envi = PlayChallenge::Environment(i);

            UI::SeparatorText(tostring(envi));
            for (uint j = 1; j <= 10; j++) {
                if (j > 1) {
                    UI::SameLine();
                }

                if (UI::Button(Text::Format("%03d", j) + "##" + i)) {
                    PlayChallenge::PlayCampaignChallengeVR(envi, j);
                }
            }
        }

        UI::EndDisabled();
        UI::TreePop();
    }

    // if (UI::TreeNode("Custom", UI::TreeNodeFlags::Framed)) {
    //     UI::BeginDisabled(demo);

    //     UI::Text("hello :)");  // TODO

    //     UI::EndDisabled();

    //     UI::TreePop();
    // }

    UI::PopFont();
}
