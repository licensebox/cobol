      *> Each field is borrowed until LB-CLOSE. A callback must not throw,
      *> STOP RUN, or reenter. Clock and binding are trusted test/platform seams.
       01 lb-callbacks.
          02 lb-context usage pointer value null.
          02 lb-on-sign-in usage program-pointer value null.
          02 lb-clock usage program-pointer value null.
          02 lb-machine-binding usage program-pointer value null.
          02 lb-cancelled usage program-pointer value null.
