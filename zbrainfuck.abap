" Report Brainfuck Interpreter
REPORT zbrainfuck. 

TYPES: tt_buffer TYPE STANDARD TABLE OF int8.

CONSTANTS: gc_buffer_size TYPE int8 VALUE 1000.

DATA: gt_buffer TYPE tt_buffer,
      gv_index  TYPE int8 VALUE 1.

FIELD-SYMBOLS: <fs_pointer> TYPE int8.

PERFORM main.

FORM main.

    DATA: lv_code TYPE string VALUE '++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.+++.'.
    
    PERFORM init_buffer CHANGING gt_buffer.
    
    READ TABLE gt_buffer INDEX gv_index ASSIGNING <fs_pointer>.
    
    PERFORM interprete_code USING lv_code.

ENDFORM.

FORM init_buffer CHANGING ct_buffer TYPE tt_buffer.

    DO gc_buffer_size TIMES.
        APPEND 0 TO ct_buffer.    
    ENDIF.

ENDFORM.

FORM interprete_code USING iv_code TYPE string.

    DATA: lv_length  TYPE int8,
          lv_command TYPE c.
    
    lv_length = strlen( iv_code ).
    
    DO lv_length TIMES.
        lv_command = iv_code+sy-index(1).
        
        WRITE lv_command. 
    
    ENDDO.

ENDFORM.

FORM interprete_char USING iv_command TYPE c.

    CASE iv_command.
        WHEN '<'.
            PERFORM decrease_pointer.
            
        WHEN '>'.
            PERFORM increment_pointer.
        
        WHEN '+'.
            PERFORM increment_value.
        
        WHEN '-'.
            PERFORM decrease_value.
        
        WHEN '.'.
            PERFORM output_value.
        
    ENDCASE. 

ENDFORM.

" Runtime Forms

FORM increment_pointer.

    IF gv_index <= gc_buffer_size.
        ADD 1 TO gv_index.
        READ TABLE gt_buffer INDEX gv_index ASSIGNING <fs_pointer>.
    ENDIF.

ENDFORM.

FORM decrease_pointer.

    IF gv_index > 1.
        SUBTRACT 1 FROM gv_index.
        READ TABLE gt_buffer INDEX gv_index ASSIGNING <fs_pointer>.
    ENDIF.

ENDFORM.

FORM increment_value.
    
    ADD 1 TO <fs_pointer>.
    
ENDFORM.

FORM decrease_value.

    SUBTRACT 1 FROM <fs_pointer>.

ENDFORM.

FORM output_value.

    WRITE: / <fs_pointer>.

ENDFORM.
