.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_IPC_MESSAGE_TO = 1
  .const OFFSET_STRUCT_IPC_MESSAGE_PRIORITY = 2
  .const OFFSET_STRUCT_IPC_MESSAGE_SEQUENCE = 3
  .const OFFSET_STRUCT_IPC_MESSAGE_MESSAGE = 4
main: {
    jsr ipc_send
  __b1:
    jsr yield
    jmp __b1
    message: .text "cpoint 6.2  "
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
ipc_send: {
    .label b = $300
    .const to = 1
    .const priority = 1
    .const sequence_number = 1
    .label a = ipc_buffer
    .label temp = ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_MESSAGE
    lda #0
    sta ipc_buffer
    lda #to
    sta ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_TO
    lda #priority
    sta ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_PRIORITY
    lda #sequence_number
    sta ipc_buffer+OFFSET_STRUCT_IPC_MESSAGE_SEQUENCE
    ldx #0
  __b1:
    cpx #$c
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
    lda main.message,x
    sta temp,x
    inx
    jmp __b1
}
  ipc_buffer: .fill $10*1, 0
