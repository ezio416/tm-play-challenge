void ClearMaps() {
    maps.DeleteAll();
    mapsVRCanyon.DeleteAll();
    mapsVRValley.DeleteAll();
    mapsVRLagoon.DeleteAll();
    mapsVRStadium.DeleteAll();

    loaded = false;
}

bool Demo() {
    return cast<CTrackMania>(GetApp()).ManiaPlanetScriptAPI.TmTurbo_IsDemo;
}

void LoadMapsAsync() {
    const uint64 start = Time::Now;
    trace("loading maps");

    auto App = cast<CTrackMania>(GetApp());

    while (App.ChallengeInfos.Length < 240) {
        yield();
    }

    ClearMaps();

    string name;
    uint num;

    for (uint i = 0; i < App.ChallengeInfos.Length; i++) {
        CGameCtnChallengeInfo@ map = App.ChallengeInfos[i];

        if (true
            and map !is null
            and map.MapUid.Length > 0
            and map.AuthorNickName == "Nadeo"
        ) {
            name = string(map.NameForUi);

            if (Text::TryParseUInt(name, num)) {
                maps.Set(tostring(num), @Map(map));

            } else if (name.StartsWith("VR_")) {
                string[]@ parts = name.Split("_");
                if (false
                    or parts.Length < 3
                    or !Text::TryParseUInt(parts[2], num)
                ) {
                    warn("invalid VR map: " + name);
                    continue;
                }

                if (parts[1] == "Canyon") {
                    mapsVRCanyon.Set(name, @Map(map));
                } else if (parts[1] == "Valley") {
                    mapsVRValley.Set(name, @Map(map));
                } else if (parts[1] == "Lagoon") {
                    mapsVRLagoon.Set(name, @Map(map));
                } else if (parts[1] == "Stadium") {
                    mapsVRStadium.Set(name, @Map(map));
                } else {
                    warn("invalid VR map: " + name);
                }
            }
        }
    }

    if (false
        or maps.GetSize() != 200
        or mapsVRCanyon.GetSize() != 10
        or mapsVRValley.GetSize() != 10
        or mapsVRLagoon.GetSize() != 10
        or mapsVRStadium.GetSize() != 10
    ) {
        NotifyError("failed to load all maps after " + (Time::Now - start) + "ms");
        ClearMaps();

    } else {
        loaded = true;
        trace("loaded maps after " + (Time::Now - start) + "ms");
    }
}

void Notify(const string&in msg, const vec4&in color) {
    if (S_Notify) {
        UI::ShowNotification(pluginTitle, msg, color);
    }
}

void NotifyError(const string&in msg) {
    error(msg);
    Notify(msg, vec4(1.0f, 0.2f, 0.0f, 1.0f));
}

void NotifyWarn(const string&in msg) {
    warn(msg);
    Notify(msg, vec4(1.0f, 0.5f, 0.0f, 1.0f));
}
