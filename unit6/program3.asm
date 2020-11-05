.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_IPC_MESSAGE_TO = 1
  .const OFFSET_STRUCT_IPC_MESSAGE_MESSAGE = 4
main: {
    .label msg = ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_MESSAGE
    .label scr = 2
    lda #<$400
    sta.z scr
    lda #>$400
    sta.z scr+1
  __b2:
    jsr ipc_read
  __b3:
    lda #$ff
    cmp ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_TO
    beq __b4
    ldy #0
  // Print message contents to screen
  __b5:
    cpy #$c
    bcc __b6
    lda #$28
    clc
    adc.z scr
    sta.z scr
    bcc !+
    inc.z scr+1
  !:
    lda.z scr+1
    cmp #>$700
    bne !+
    lda.z scr
    cmp #<$700
  !:
    bcc __b2
    beq __b2
  __b8:
    jmp __b8
  __b6:
    lda msg,y
    sta (scr),y
    iny
    jmp __b5
  __b4:
    jsr yield
    jsr ipc_read
    jmp __b3
}
ipc_read: {
    .label b = $300
    .label a = ipc_buffer
    jsr enable_syscalls
    lda #0
    sta $d649
    nop
    tax
  __b1:
    cpx #$10
    bcc __b2
    rts
  __b2:
    lda b,x
    sta a,x
    inx
    jmp __b1
}
enable_syscalls: {
    lda #$47
    sta $d02f
    lda #$53
    sta $d02f
    rts
}
yield: {
    jsr enable_syscalls
    lda #0
    sta $d645
    nop
    rts
}
  ipc_buffer: .fill $10*1, 0
