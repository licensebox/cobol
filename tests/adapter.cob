       >>source format free
identification division.
program-id. adapter.
data division.
working-storage section.
01 op pic x(32).
01 product-name pic x(256).
01 source-name pic x(64).
01 raw-id pic x(1024).
01 token-value pic x(32768).
01 keys-json pic x(32768).
01 time-text pic x(64).
01 binding-value pic x(256).
01 options-json pic x(65536).
01 args-json pic x(4096).
01 result-json pic x(1048576).
01 error-code pic x(64).
01 temp-binding pic x(128).
01 client-handle usage pointer value null.
01 callback-pointer usage pointer value null.
01 now-seconds usage float-long.
procedure division.
    call static "read_field" using by reference op by value length of op
    call static "read_field" using by reference product-name by value length of product-name
    call static "read_field" using by reference source-name by value length of source-name
    call static "read_field" using by reference raw-id by value length of raw-id
    call static "read_field" using by reference token-value by value length of token-value
    call static "read_field" using by reference keys-json by value length of keys-json
    call static "read_field" using by reference time-text by value length of time-text
    call static "read_field" using by reference binding-value by value length of binding-value
    call static "read_field" using by reference options-json by value length of options-json
    call static "read_field" using by reference args-json by value length of args-json
    move function numval(time-text) to now-seconds
    move spaces to error-code result-json
    evaluate function trim(op)
      when "derive"
        call "LB-DERIVE" using product-name source-name raw-id temp-binding error-code
        if error-code = spaces
          string '"' function trim(temp-binding) '"' into result-json end-string
        end-if
      when "native"
        call "LB-NATIVE" using product-name temp-binding error-code
        if error-code = spaces
          string '"' function trim(temp-binding) '"' into result-json end-string
        end-if
      when "verify"
        call "LB-VERIFY" using token-value product-name keys-json now-seconds result-json error-code
      when other
        call static "synthetic_callbacks" using by reference time-text binding-value
          by value length of binding-value returning callback-pointer
        call "LB-CREATE" using options-json callback-pointer client-handle error-code
        if error-code = spaces
          evaluate function trim(op)
            when "require" continue
            when "repeat"
              move "require" to op
              move '{"module":"core"}' to args-json
              call "LB-CALL" using client-handle op args-json result-json error-code
            when "sign_in" move '{"timeout":3}' to args-json
            when "request" move '{"modules":["export"],"note":"café – test"}' to args-json
            when "record"
              move '{"command":"export","success":true,"elapsed":0.125}' to args-json
              call "LB-CALL" using client-handle op args-json result-json error-code
              move '{"command":"export","success":false,"elapsed":0.025}' to args-json
            when other move '{}' to args-json
          end-evaluate
          if error-code = spaces
            call "LB-CALL" using client-handle op args-json result-json error-code
          end-if
        end-if
        call "LB-CLOSE" using client-handle
    end-evaluate
    call static "write_field" using by reference error-code by value length of error-code
    call static "write_field" using by reference result-json by value length of result-json
    move 0 to return-code
    stop run.
