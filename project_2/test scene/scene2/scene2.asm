.data 0x0000
	buf: .word 0x0000
.text 0x0000
start:
	lui  $t1,0xFFFF
        ori  $t7,$t1,0xF000
        and  $t2, $zero, $zero
	ori $s0,$zero,0
	ori $s1,$zero,1
	ori $s2,$zero,2
	ori $s3,$zero,3
	ori $s4,$zero,4
	ori $s5,$zero,5
	ori $s6,$zero,6
	ori $s7,$zero,7
switled:
	lw    $t1,0xC72($t7)
	srl   $t1,$t1,5
	beq   $t1,$s0,zzz
	beq   $t1,$s1,zzo
	beq   $t1,$s2,zoz
	beq   $t1,$s3,zoo
	beq   $t1,$s4,ozz
	beq   $t1,$s5,ozo
	beq   $t1,$s6,ooz
	beq   $t1,$s7,ooo
zzz:
	lw $t5,0xC70($t7)
	sll   $t5,$t5,24
	srl   $t5,$t5,24
	lw $t6,0xC70($t7)
	srl   $t6,$t6,8
	lw    $t1,0xC70($t7)
	sw    $t1,0xC60($t7)
	j switled
zzo:
	addu $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
zoz:
	subu $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
zoo:
	sllv $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
ozz:
	srlv $t1, $t5, $t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
ozo:
	sltu $t1,$t6,$t5
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
ooz:
	and $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
ooo:
	xor $t1,$t5,$t6
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	j switled
