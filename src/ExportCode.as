namespace PlayChallenge {
    void PlayCampaignChallenge(const uint num) {
        if (false
            or num == 0
            or num > 200
            or (true
                and num > 5
                and Demo()
            )
        ) {
            NotifyError("invalid map number: " + num);
            return;
        }

        Map@ map;
        if (maps.Get(tostring(num), @map)) {
            map.Play();
        } else {
            NotifyError("map number not found: " + num);
        }
    }

    void PlayCampaignChallengeVR(const Environment environment, const uint num) {
        if (false
            or num == 0
            or num > 10
            or Demo()
        ) {
            NotifyError("invalid map number: " + num);
            return;
        }

        dictionary@ dict;

        switch (environment) {
            case Environment::Canyon:  @dict = mapsVRCanyon;  break;
            case Environment::Valley:  @dict = mapsVRValley;  break;
            case Environment::Lagoon:  @dict = mapsVRLagoon;  break;
            case Environment::Stadium: @dict = mapsVRStadium; break;

            default:
                NotifyError("invalid environment: " + tostring(environment));
                return;
        }

        Map@ map;
        if (dict.Get(tostring(num), @map)) {
            map.Play();
        } else {
            NotifyError("map number not found: " + num);
        }
    }
}
