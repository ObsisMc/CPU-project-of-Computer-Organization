.data 0x0000
	buf: .word 0x0000
	zero: .word 0
	one: .word 1
	two: .word 2
	three:.word 3
	four: .word 4
	five:.word 5
	six: .word 6
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
switled:
	lw    $t1,0xC72($t7)
#	sw    $t1,0xC62($t7)
	srl   $t1,$t1,5
	beq   $t1,$s0,zzz
	beq   $t1,$s1,zzo
	beq   $t1,$s2,zoz
	beq   $t1,$s3,zoo
	beq   $t1,$s4,ozz
	beq   $t1,$s5,ozo
	beq   $t1,$s6,ooz

zzz:
	#addi $t2, $t2, 1
	#div $t2, $s2
	#mfhi $t2
	#beq $t2,$s1,zzzo
	ori $t1,$zero,0x5555
	sw $t1,0xC60($t7)
	#j switled
	nop
	nop
	nop
zzzo:
	ori $t1,$zero,0xAAAA
	sw  $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
zzo:
	lw   $t1,0xC70($t7)
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
zoz:
	lw $t1,buf($zero) 
	addi $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
zoo:
	lw $t1,buf($zero) 
	addi $t1, $t1, -1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
ozz:
	lw $t1,buf($zero) 
	sll $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
ozo:
	lw  $t1,buf($zero) 
	srl $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
ooz:
	lw $t1,buf($zero) 
	sra $t1, $t1, 1
	sw   $t1, buf($zero) 
	lw   $t1, buf($zero) 
	nop
	sw   $t1,0xC60($t7)
	sll  $t1,$t1,15
	srl  $t1,$t1,31
	sw   $t1,0xC62($t7)
	j switled
