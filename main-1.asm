;
; 25kasim2.asm
;
; Created: 25.11.2017 13:15:41
; Author : NAIME
;

;
; 25kasim1.asm
;
; Created: 25.11.2017 12:16:45
; Author : NAIME
;


;
; AssemblerApplication6.asm
;
; Created: 24.11.2017 15:19:19
; Author : NAIME
;

.org 0
   rjmp main
main:
   ldi r23,0xFF 	; 0x20=0010 0000 -> PORTB nin 5. pinini output yapmak istiyoruz, o nedenle 5. bit 1
   out DDRC,r23		; PortB nin data direction registeri DDRB ye r16 daki degeri yaziyoruz
   ;clr r17			; r17 yi LED imizi yakip sondurmek icin gecici olarak kullanacagiz.
   ldi r17, 0x01
   ldi r16,0x70
   ldi r18,0x01
   ldi r19, 0x01
   ldi r23, 0x01
   ldi r21, 0x01
   ldi r22,0x01
   ldi r24,0x01
   ldi r25, 0x02
   
   ldi r26, 0x02

   ldi r27, 0x90
   ldi r28, 0x50
   ldi r29, 0x01

   sbi PORTB, 2
   sbi PORTB,1
   sbi PORTB, 0
mainloop:
   ;clz
   
   out PORTC,r23 	; r17 deki degeri PORTB ye yaziyoruz.
   call wait 		; 700ms lik bekleme fonksiyonumuzu cagiriyoruz.,,

   

   sbis PINB,0
   rjmp hizlan

   sbis PINB, 1
   rjmp artirma

   sbis PINB,2
   inc r19
   and r19,r21
   breq sagyon
   brne solyon
   
  

sol:  ; hepsi sifirlip sifirlnmadigini konrol ediyoýr
    
   brlo soldegerdegistir	; programin mainloop etiketine giderek sonsuz dongude calismasini sagliyoruz.
   rjmp mainloop
sag: ; hepsi sifirlip sifirlnmadigini konrol ediyoýr
	brlo sagdegerdegistir
	rjmp mainloop
sagdegerdegistir: ;sifirlanirsa yeniden deger atiyor
	clc
	cpse r25, r26
	rjmp fonksag
	ldi r23, 0x80
	rjmp mainloop
soldegerdegistir: ;sifirlanirsa yeniden deger atiyor
	clc
	cpse r25, r26
	rjmp fonksol
	
	ldi r23, 0x01
	rjmp mainloop
solyon: ;yonlendirme sola dogru
	rol r23
	rjmp sol
sagyon: ;yonlendirme soga dogru
	ror r23
	rjmp  sag

artirma:
	
	subi r18, 0x01
	breq ikiartir

	subi r18, 0x02
	breq ucartir

ucartir:
	
	ldi r24, 0x04
	sbrc r23, 0
	rjmp fonkuc
	lsr r24
	sbrc r23, 1
	rjmp fonkuc
	lsl r24
	
	sbrc r23, 2
	rjmp fonkuc
	lsl r24

	sbrc r23, 3
	rjmp fonkuc
	lsl r24

	sbrc r23, 4
	rjmp fonkuc
	lsl r24

	sbrc r23, 5
	rjmp fonkuc
	lsl r24
	
	sbrc r23, 6
	rjmp fonkuc
	lsl r24


	sbrc r23, 7
	rjmp fonkuc

fonkuc: ; mainloop a yeni degeri gonderir
	
	ldi r25, 0x01
	add r23,r24
	rjmp mainloop

ikiartir: ; iki artirma yapar
	ldi r18, 0x02

	inc r24
	sbrc r23, 0
	rjmp fonk
	lsr r24
	sbrc r23, 1
	rjmp fonk
	lsl r24
	
	sbrc r23, 2
	rjmp fonk
	lsl r24

	sbrc r23, 3
	rjmp fonk
	lsl r24

	sbrc r23, 4
	rjmp fonk
	lsl r24

	sbrc r23, 5
	rjmp fonk
	lsl r24
	
	sbrc r23, 6
	rjmp fonk
	lsl r24


	sbrc r23, 7
	rjmp fonk
fonksol: ;sola giderken sifirlnamasini engeller
	
	ldi r23, 0x40
	sec
	rol r23
	out PORTC, r23
	call wait
	ldi r23, 0x03
	rjmp mainloop
fonksag: ;saga dogru ilerlerken sifirlanmasini engeller
	ldi r23, 0x02
	sec
	ror r23
	out PORTC, r23
	call wait
	ldi r23, 0xC0
	rjmp mainloop
fonk: ; mainloop a yeni degeri gonderir
	
	ldi r25, 0x01
	add r23,r24
	
	rjmp mainloop
hizlan:
	rjmp mainloop

wait:	
				; 700ms lik bekleme saglayan fonksiyonumuz
   push r16			; mainloop icerisinde kullandigimiz r16 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
   push r17			; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz
   
  ; ldi r16,0x50 	; 0x400000 kere dongu calistirilacak
   
   ldi r17,0x01 	; ~12 milyon komut cycle i surecek
   ldi r18,0x00 	; 16Mhz calisma frekansi icin ~0.7s zaman gecikmesi elde edilecek
_w0:
   dec r18			; r18 deki degeri 1 azalt
   brne _w0			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r17			; r17 deki degeri 1 azalt
   brne _w0			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r16			; r16 daki degeri 1 azalt
   brne _w0			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   pop r17			; fonksiyondan donmeden once en son push edilen r17 yi geri cek
   pop r16			; r16 yi geri cek
   ret				; fonksiyondan geri don


