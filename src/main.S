  .syntax unified
  .global main
  .type main, %function

@ for details on how this assignment template works, see
@ https://cs.anu.edu.au/courses/comp2300/assignments/01-synth/#getting-started

main:
  bl init @ call init function
  .size main, .-main

main2:
  bl setup_A @ each setup function is called to generate a specific sound
  bl setup_pause_half @ this function is called to pause for half a second
  bl setup_C
  bl setup_pause_half
  bl setup_A
  bl setup_pause_quarter @ this function is called to pause for 0.25 second
  bl setup_A
  bl setup_pause_half
  bl setup_C
  bl setup_pause_half
  bl setup_A
  bl setup_pause_quarter
  bl setup_A
  bl setup_pause_half
  bl setup_C
  bl setup_pause_half
  bl setup_A
  bl setup_pause_quarter
  bl setup_B
  bl setup_pause_half
  bl setup_A
  bl setup_pause_half
  bl setup_G
  bl setup_pause_quarter
  b main2 
  @ when the sequence comes to the end, go back to the top and replay the sequence

func_return:
  @ this function is created to pop the original link register and return to the address where the function been called
  pop {lr}
  bx lr

setup_A:
  push {lr} @ save the 'lr' value in the stack
  ldr r4, =0x8000 @ set a bottom value for the sound
  mov r5, 109 @ which is a counter in the 'note_A' function. when it comes to 0, it will reset the value
  ldr r6, =12000 @ this is a time counter, which runs for 0.25 second
  b note_A

note_A:
  mov r0, r4 @ move the value in r4 to r0 to generate the sound
  bl BSP_AUDIO_OUT_Play_Sample
  subs r6, 1 @ in each loop, the time counter will subtract 1
  beq func_return @ when the time counter goes to 0, pop the 'lr' value and the function comes to an end
  subs r5, 1 @ this counter is set to prevent an overflow case to occur
  beq reset_A @ when r5 comes to 0, reset the values for r4 & r5
  add r4, 601 @ in each loop, r4 will add 601 to generate the 440hz sound
  b note_A @ start the next loop

reset_A:
  ldr r4, =0x8000 @ reset the values for r4 & r5
  mov r5, 109
  b note_A

setup_C:
  push {lr}
  ldr r4, =0x8000
  mov r5, 92
  ldr r6, =12000
  b note_C

note_C:
  mov r0, r4
  bl BSP_AUDIO_OUT_Play_Sample
  subs r6, 1
  beq func_return
  subs r5, 1
  beq reset_C
  add r4, 712
  b note_C

reset_C:
  ldr r4, =0x8000
  mov r5, 92
  b note_C

setup_B:
  push {lr}
  ldr r4, =0x8000
  mov r5, 97
  ldr r6, =12000
  b note_B

note_B:
  mov r0, r4
  bl BSP_AUDIO_OUT_Play_Sample
  subs r6, 1
  beq func_return
  subs r5, 1
  beq reset_B
  add r4, 675
  b note_B

reset_B:
  ldr r4, =0x8000
  mov r5, 97
  b note_B

setup_G:
  push {lr}
  ldr r4, =0x8000
  mov r5, 122
  ldr r6, =12000
  b note_G

note_G:
  mov r0, r4
  bl BSP_AUDIO_OUT_Play_Sample
  subs r6, 1
  beq func_return
  subs r5, 1
  beq reset_G
  add r4, 537
  b note_G

reset_G:
  ldr r4, =0x8000
  mov r5, 122
  b note_G

setup_pause_quarter:
  push {lr}
  ldr r6, =12000 @ r6 is a time counter, stands for 0.25 second
  b pause

setup_pause_half:
  push {lr}
  ldr r6, =24000 @ this will run 0.5 second
  b pause

pause:
  mov r0, 0 @ when the value in r0 stick to 0, it will demonstrate a pause of the sound
  bl BSP_AUDIO_OUT_Play_Sample
  subs r6, 1
  beq func_return @ when the time counter goes to 0, the function comes to an end
  b pause

