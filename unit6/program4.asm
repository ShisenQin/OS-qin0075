.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_IPC_MESSAGE_TO = 1
  .const OFFSET_STRUCT_IPC_MESSAGE_PRIORITY = 2
  .const OFFSET_STRUCT_IPC_MESSAGE_SEQUENCE = 3
  .const OFFSET_STRUCT_IPC_MESSAGE_MESSAGE = 4
main: {
    lda #<message
    sta.z ipc_send.message
    lda #>message
    sta.z ipc_send.message+1
    ldx #$ff
    jsr ipc_send
    lda #<message1
    sta.z ipc_send.message
    lda #>message1
    sta.z ipc_send.message+1
    ldx #$c8
    jsr ipc_send
    lda #<message2
    sta.z ipc_send.message
    lda #>message2
    sta.z ipc_send.message+1
    ldx #$c7
    jsr ipc_send
    lda #<message3
    sta.z ipc_send.message
    lda #>message3
    sta.z ipc_send.message+1
    ldx #$c6
    jsr ipc_send
    lda #<message2
    sta.z ipc_send.message
    lda #>message2
    sta.z ipc_send.message+1
    ldx #1
    jsr ipc_send
    lda #<message5
    sta.z ipc_send.message
    lda #>message5
    sta.z ipc_send.message+1
    ldx #$64
    jsr ipc_send
    lda #<message6
    sta.z ipc_send.message
    lda #>message6
    sta.z ipc_send.message+1
    ldx #$f0
    jsr ipc_send
  __b1:
    jsr yield
    jmp __b1
    message: .text "checkpoint  "
    .byte 0
    message1: .text "4           "
    .byte 0
    message2: .text "------------"
    .byte 0
    message3: .text "moremessages"
    .byte 0
    message5: .text "3           "
    .byte 0
    message6: .text "6.          "
    .byte 0
}
yield: {
    jsr enable_syscalls
    lda #0
    sta $d645
    nop
    rts
}
enable_syscalls: {
    lda #$47
    sta $d02f
    lda #$53
    sta $d02f
    rts
}
/*
  Write to $D64A to trigger SYSCALL $0A after copying the message details to the transfer area beginning at $0300.
 */
// ipc_send(byte register(X) priority, byte* zeropage(2) message)
ipc_send: {
    .label b = $300
    .label a = ipc_buffer
    .label temp = ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_MESSAGE
    .label message = 2
    lda #0
    sta ipc_buffer
    lda #1
    sta ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_TO
    stx ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_PRIORITY
    sta ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_SEQUENCE
    ldy #0
  __b1:
    cpy #$c
    bcc __b2
    ldx #0
  __b3:
    cpx #$10
    bcc __b4
    jsr enable_syscalls
    lda #0
    sta $d64a
    nop
    rts
  __b4:
    lda a,x
    sta b,x
    inx
    jmp __b3
  __b2:
    lda (message),y
    sta temp,y
    iny
    jmp __b1
}
  ipc_buffer: .fill $10*1, 0
