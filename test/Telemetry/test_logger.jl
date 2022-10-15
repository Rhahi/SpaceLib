using SpaceLib
using Test


@testset begin
    main("test_logger", log_path=homedir()*"/spacelib/unittest") do sp
        file = sp.system.home * "/csv_logtest.csv"
        Telemetry.telemetry!(sp, :csv_logtest, foo=0, bar=1)
        Telemetry.telemetry!(sp, :csv_logtest, foo=0, bar=1)

        # close the file, so that it's updated for read.
        file_handler = sp.system.ios[:csv_logtest]
        close(file_handler)
        @test isfile(file)
        io = open(file, "r")
        @test countlines(io) == 3

        # store it back, so that we don't close already closed stream.
        sp.system.ios[:csv_logtest] = io
    end
end
