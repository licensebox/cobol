       >>source format free
identification division.
program-id. binding-test.
data division.
working-storage section.
01 product-name pic x(4) value "demo".
01 source-name pic x(16) value "linux-machine-id".
01 raw-id pic x(32) value "12345678123456789abc1234567890ab".
01 binding-value pic x(128).
01 error-code pic x(64).
01 options-json pic x(512) value
 '{"product":"demo","keys":{"k":"A6EHv_POEL4dcN0Y50vAmWfk1jCbpQ1fHdyGZBJVMbg"},"directory":"build/test-state"}'.
01 callback-pointer usage pointer value null.
01 client-handle usage pointer value null.
01 operation-name pic x(16).
01 args-json pic x(2) value "{}".
01 result-json pic x(4096).
procedure division.
    call "LB-DERIVE" using product-name source-name raw-id binding-value error-code
    if error-code not = spaces move 1 to return-code stop run end-if
    if function trim(binding-value) not =
       "m1:linux-machine-id:783b8906a4af61095e68f3f0b4468a953be69ddd7afcf35850b501a7361f309e"
       move 2 to return-code stop run end-if
    call "LB-CREATE" using options-json callback-pointer client-handle error-code
    if error-code not = spaces display error-code move 3 to return-code stop run end-if
    move "status" to operation-name
    call "LB-CALL" using client-handle operation-name args-json result-json error-code
    if error-code not = "not_signed_in" move 4 to return-code stop run end-if
    move "logout" to operation-name
    call "LB-CALL" using client-handle operation-name args-json result-json error-code
    if error-code not = spaces move 5 to return-code stop run end-if
    call "LB-CLOSE" using client-handle
    call "LB-CLOSE" using client-handle
    call "LB-CALL" using client-handle operation-name args-json result-json error-code
    if error-code not = "invalid_argument" move 6 to return-code stop run end-if
    display "binding checks passed"
    move 0 to return-code
    stop run.
