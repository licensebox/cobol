       >>source format free
identification division.
program-id. status-example.
data division.
working-storage section.
01 options-json pic x(256) value '{"product":"your-product","keys":{"current":"YOUR_PUBLIC_KEY"}}'.
01 callback-pointer usage pointer value null.
01 client-handle usage pointer value null.
01 operation-name pic x(7) value "require".
01 args-json pic x(17) value '{"module":"core"}'.
01 result-json pic x(32768).
01 error-code pic x(64).
procedure division.
    call "LB-CREATE" using options-json callback-pointer client-handle error-code
    if error-code = spaces
      call "LB-CALL" using client-handle operation-name args-json result-json error-code
    end-if
    if error-code = spaces display function trim(result-json)
    else display function trim(error-code) end-if
    call "LB-CLOSE" using client-handle
    move 0 to return-code
    stop run.
