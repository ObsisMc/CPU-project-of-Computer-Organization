.data 0x0000
	buf: .word 0x0000
.text 0x0000
start:
	lui  $t1,0xFFFF
        ori  $t7,$t1,0xF000
        and  $t2, $zero, $zero
	ori $s0,$zero,0x08
	ori $s1,$zero,0x28
	ori $s2,$zero,0x48
	ori $s3,$zero,0x68
	ori $s4,$zero,0x88
	ori $s5,$zero,0xA8
switled:
	lw    $t1,0xC62($t7)
	beq   $t1,$s0,zzz
	beq   $t1,$s1,zzo
	beq   $t1,$s2,zoz
	beq   $t1,$s3,zoo
	beq   $t1,$s4,ozz
	beq   $t1,$s5,ozo

zzz:
	ori $t1,$zero,0x5
	sw $t1,0xC60($t7)
	nop
	nop
	nop
	nop
	nop
	ori $t1,$zero,0xA
	sw  $t1,0xC60($t7)
	j switled
zzo:
	lw   $t1,0xC60($t7)
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
zoz:
	lw $t1,buf($zero) 
	addi $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
zoo:
	lw $t1,buf($zero) 
	addi $t1, $t1, -1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
ozz:
	lw $t1,buf($zero) 
	sll $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
ozo:
	lw  $t1,buf($zero) 
	srl $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
