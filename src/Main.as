const string  pluginColor = "\\$0F0";
const string  pluginIcon  = Icons::Play;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

const vec3 colorWhite = vec3(0.85f);
const vec3 colorGreen = vec3(0.35f, 0.62f, 0.0f);
const vec3 colorBlue  = vec3(0.0f, 0.26f, 0.7f);
const vec3 colorRed   = vec3(0.65f, 0.0f, 0.0f);
const vec3 colorBlack = vec3(0.2f);

const PlayChallenge::Environment[] envis = {
    PlayChallenge::Environment::Canyon,
    PlayChallenge::Environment::Valley,
    PlayChallenge::Environment::Lagoon,
    PlayChallenge::Environment::Stadium
};

string     customPath;
bool       loaded = false;
dictionary maps;
dictionary mapsVRCanyon;
dictionary mapsVRLagoon;
dictionary mapsVRStadium;
dictionary mapsVRValley;

void Main() {
    OnEnabled();
}

void OnDestroyed() {
    ClearMaps();
    customPath = "";
}

void OnDisabled() {
    OnDestroyed();
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
    const bool demo = PlayChallenge::Demo();

    const float scale = UI::GetScale();

    const vec2 pre = UI::GetCursorPos();
    UI::Dummy(vec2(scale * 482.0f, 0.0f));
    UI::SetCursorPos(pre);

    UI::PushFont(UI::Font::DefaultBold);

    if (UI::TreeNode("Campaign", UI::TreeNodeFlags::Framed)) {
        for (uint i = 1; i <= 200; i++) {
            if ((i - 1) % 10 > 0) {
                UI::SameLine();
            }

            if (i <= 40) {
                UI::PushStyleColor(UI::Col::Button, vec4(colorWhite, 1.0f));
                UI::PushStyleColor(UI::Col::Text, vec4(vec3(), 1.0f));
            } else if (i <= 80) {
                UI::PushStyleColor(UI::Col::Button, vec4(colorGreen, 1.0f));
            } else if (i <= 120) {
                UI::PushStyleColor(UI::Col::Button, vec4(colorBlue, 1.0f));
            } else if (i <= 160) {
                UI::PushStyleColor(UI::Col::Button, vec4(colorRed, 1.0f));
            } else {
                UI::PushStyleColor(UI::Col::Button, vec4(colorBlack, 1.0f));
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

    if (UI::TreeNode("Custom", UI::TreeNodeFlags::Framed)) {
        UI::BeginDisabled(demo);

        UI::Text("Path to Challenge:");

        UI::SetNextItemWidth(scale * 376.0f);
        customPath = UI::InputText("##input-path", customPath);

        UI::BeginDisabled(customPath.Length == 0);

        UI::SameLine();
        if (UI::Button(Icons::Play)) {
            PlayChallenge::PlayCustomChallenge(customPath);
        }

        UI::SameLine();
        if (UI::Button(Icons::TrashO)) {
            customPath = "";
        }

        UI::EndDisabled();

        UI::Text("Examples:");
        UI::TextWrapped("- Campaigns\\01_White\\01_Canyon\\001.Map.Gbx");
        UI::TextWrapped("- VR\\01_White\\01_Canyon\\VR_Canyon_001.Map.Gbx");

        UI::EndDisabled();
        UI::TreePop();
    }

    UI::PopFont();
}
