namespace PlayChallenge {
    bool Loaded() {
        return loaded;
    }

    bool PlayCampaignChallenge(const uint num) {
        if (!loaded) {
            NotifyError("maps are not loaded");
            return false;
        }

        if (false
            or num == 0
            or num > 200
            or (true
                and num > 5
                and Demo()
            )
        ) {
            NotifyError("invalid map number: " + num);
            return false;
        }

        Map@ map;
        if (maps.Get(tostring(num), @map)) {
            map.Play();
            return true;
        } else {
            NotifyError("map number not found: " + num);
            return false;
        }
    }

    bool PlayCampaignChallengeVR(const Environment environment, const uint num) {
        if (!loaded) {
            NotifyError("maps are not loaded");
            return false;
        }

        if (false
            or num == 0
            or num > 10
            or Demo()
        ) {
            NotifyError("invalid map number: " + num);
            return false;
        }

        dictionary@ dict;

        switch (environment) {
            case Environment::Canyon:  @dict = mapsVRCanyon;  break;
            case Environment::Valley:  @dict = mapsVRValley;  break;
            case Environment::Lagoon:  @dict = mapsVRLagoon;  break;
            case Environment::Stadium: @dict = mapsVRStadium; break;

            default:
                NotifyError("invalid environment: " + tostring(environment));
                return false;
        }

        Map@ map;
        if (dict.Get(tostring(num), @map)) {
            map.Play();
            return true;
        } else {
            NotifyError("map number not found: " + num);
            return false;
        }
    }

    bool PlayCustomChallenge(const string&in path) {
        if (Demo()) {
            NotifyError("demo can't play custom maps");
            return false;
        }

        Map(path).Play();
        return true;
    }
}
