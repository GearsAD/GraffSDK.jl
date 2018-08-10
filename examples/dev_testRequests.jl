using SynchronySDK
using JSON, Unmarshal


br = BearingRangeRequest("x1", "l1",
                    DistributionRequest("Normal", Float64[0; 0.1]),
                    DistributionRequest("Normal", Float64[20; 1.0]) )


br

brBody = JSON.json(br)

brRequest = Unmarshal.unmarshal(BearingRangeRequest, JSON.parse(brBody))



#
