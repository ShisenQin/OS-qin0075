.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_IPC_MESSAGE_MESSAGE = 4
main: {
    .label msg = ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_MESSAGE
    .label __3 = 2
    jsr ipc_read
    ldx #0
  // Print message contents to screen
  __b1:
    cpx #$c
    bcc __b2
  __b3:
    jmp __b3
  __b2:
    txa
    clc
    adc #<$400
    sta.z __3
    lda #>$400
    adc #0
    sta.z __3+1
    lda msg,x
    ldy #0
    sta (__3),y
    inx
    jmp __b1
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
  ipc_buffer: .fill $10*1, 0
