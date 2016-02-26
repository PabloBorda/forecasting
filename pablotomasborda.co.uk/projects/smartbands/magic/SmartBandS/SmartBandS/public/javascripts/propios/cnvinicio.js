function draw() {
	var x = 67;
	var y = 128;
	var radio = 15;
	var anchoLinea = 450;
      var canvas = document.getElementById("micanvas");
      if (canvas.getContext) {
        var ctx = canvas.getContext("2d");
		ctx.beginPath();
		ctx.fillStyle = '#F92D32';
		ctx.moveTo(x-radio,145);
		ctx.arc(x,y,radio,Math.PI,Math.PI*1.5,false); // círculo exterior
		ctx.lineTo(anchoLinea,y-radio);
		ctx.arc(anchoLinea,y,radio,Math.PI*1.5,Math.PI*0,false);
		ctx.lineTo(anchoLinea + radio,y+17);
		ctx.stroke();
		ctx.fill();
		ctx.stroke();
		ctx.closePath();
		/*Linea de base
		ctx.beginPath();
		ctx.moveTo(x-radio,y);
		ctx.lineTo(anchoLinea+radio,y);
		ctx.strokeStyle = '#F92D32';
		ctx.stroke();
		ctx.closePath();
		*/
		
		// SmartBandS
		ctx.beginPath();
		ctx.fillStyle = '#333';
		ctx.moveTo(x+anchoLinea, y);
		ctx.font = '40px Lucida Calligraphy';
		ctx.fillText("smart",500,140);
		ctx.font = '40px Magneto';
		ctx.fillText("B    S",630,140);
		ctx.font = '20px Lucida Calligraphy';
		ctx.fillText("AND",661,135);
		ctx.stroke();
		
      }
}
	/*		
			context.moveTo(35, 147);
			context.lineTo(35, 120);
			context.lineTo(450, 120);
			context.lineTo(450, 147);
			context.fill();	
			
			
      		context.lineWidth = 15;

	//		context.lineTo(35, 148);
//			context.lineTo(35, 120);
			context.lineJoin = 'round';
			context.strokeStyle = '#F92D32';
			context.stroke();
			
			// SmartBandS
			context.beginPath();
	//		context.moveTo(379, 150);
	//		context.lineTo(429, 50);
	//		context.lineTo(479, 150);
	//		  context.lineJoin = 'bevel';
	//		  context.stroke();
			  
		     // escalo el contexto (amplío)
			context.scale(0.5, 1);  //.scale(ancho, alto)
		   // cambiamos el color de llenado del contexto
			context.fillStyle = '#333';
 			// asignamos al contexto el tipo de letra, tamaño y posicion inicial
			context.font = '70px sans-serif';
		//	contexto.textBaseline = 'top';
			// dibujamos el texto
			context.textBaseline="hanging"; 
			context.fillText("smartBandS",500,80);
			//contexto.fillText('JS', 25, 5); // fillText(texto, x, y);
			
		*/	
	
	
		
/*		var contexto = elemento.getContext('2d');
		if (contexto) {
		   contexto.fillStyle = '#F92D32';
		   contexto.lineWidth = 1;
           contexto.strokeStyle = 'black';
		   var x = 45
		   var y = 148;
		   var radio = 35;
		   var ancho = 435;
		   contexto.beginPath();
		   contexto.arc(x,y,radio,Math.PI,Math.PI*1.5,false);
		   contexto.lineTo(ancho,y-radio);
		   contexto.fill();
		   contexto.stroke();
   		   contexto.arc(ancho,y,radio,Math.PI*1.5,Math.PI*0,false);
	   	   contexto.fill();
		   contexto.stroke();
		   contexto.closePath();
		   
		   // escalo el contexto (amplío)
			contexto.scale(0.8, 1);  //.scale(ancho, alto)
		   // cambiamos el color de llenado del contexto
			contexto.fillStyle = '#333';
			contexto.
 			// asignamos al contexto el tipo de letra, tamaño y posicion inicial
			contexto.font = '64px sans-serif';
		//	contexto.textBaseline = 'top';
			// dibujamos el texto
			contexto.textBaseline="hanging"; 
			contexto.fillText("smartBandS",500,80);
			//contexto.fillText('JS', 25, 5); // fillText(texto, x, y);
	*/	
		
		
		   
	/*
		   contexto.fill();
		   contexto.lineTo(ancho+x,y);
		   contexto.arc(ancho,y,radio,Math.PI*1.5,Math.PI*0,false);
		   
		    contexto.closePath();
			
			*/

		   /*
		   contexto.moveTo(ancho,y);
		   		   	contexto.stroke(); 

		   contexto.arc(ancho,y,radio,Math.PI*1.5,Math.PI*0,false);
		   */
		  
//		   contexto.fill();
		 
		 
		 /*contexto.beginPath();
		   contexto.arc(ancho,y,radio,Math.PI*1.5,Math.PI*0,false);
		   contexto.lineTo(ancho,y);
		   contexto.closePath()
		   contexto.fill();
		   		   				   contexto.stroke();
								   */


			
		//Si tengo el contexto 2d es que todo ha ido bien y puedo empezar a dibujar 
		//Comienzo dibujando un rectángulo
		//contexto.fillRect(10, 10, 20, 210);  //fillRect(x,y,anchura,altura)
		//cambio el color de estilo de dibujo a rojo
	/*	contexto.fillStyle = 'rgba(240,30,0,0.9);'
		//dibujo otro rectángulo
		contexto.fillRect(0, 0, 1600, 4000);
		/*
		//cambio el color de dibujo a azul
contexto.fillStyle = '#6666ff';
//dibujo un rectángulo azul
contexto.fillRect(10,10,50,50); 
//cambio el color a amarillo con un poco de transparencia
contexto.fillStyle = 'rgba(240,30,0,0.9);' <!-- 'rgba(20,230,100,0.4)'; rgba(255,0,0,0.4);-->
//pinto un rectángulo amarillo semitransparente
contexto.fillRect(35,35,50,50);

for (i=0;i<=100;i+=10){
   contexto.fillRect(i,i,5,5);
}

for (i=100;i>=0;i-=10){
   contexto.strokeRect(i,100-i,5,5);
}

contexto.clearRect(60,0,42,150);




	 contexto.fillStyle = '#4444ff';
	contexto.beginPath();
	contexto.moveTo(50,5);
	contexto.lineTo(75,65);
	contexto.lineTo(50,125);
	contexto.lineTo(25,65);
	contexto.stroke();
	
	contexto.beginPath();
	contexto.moveTo(1,1);
	for (i=1;i<100;i+=5){
   		if((i%2)!=0){
     	 contexto.lineTo(i+5,i);
   		}else{
    	  contexto.lineTo(i,i+5);
   		}
	}

contexto.stroke()


   //primer camino
   contexto.beginPath();
   contexto.moveTo(20,10);
   contexto.lineTo(32,20);
   contexto.lineTo(22,20);
   contexto.lineTo(22,35);
   contexto.lineTo(17,35);
   contexto.lineTo(17,20);
   contexto.lineTo(7,20);
   //ctx.closePath(); opcional antes de un fill()
   contexto.fill();
   
   //creo un segundo camino
   contexto.beginPath(); //probar a comentar esta línea para ver lo que pasa
   contexto.fillStyle = '#ff8800';
   contexto.moveTo(47,50);
   contexto.lineTo(67,70);
   contexto.lineTo(67,30);
   contexto.closePath();
   contexto.fill();
   */
   
   //primer camino, en negro
   
   
   
//   contexto.arc(x+900,y,radio,Math.PI,Math.PI*1.5,false);
   
   
   
   //contexto.arc(75,75,32,Math.PI*0.5,Math.PI*1,false);


 /*  //segundo camino, en naranja
   contexto.fillStyle = '#ff8800';
   contexto.beginPath();
   contexto.arc(75,75,15,0,Math.PI*2,false);
   contexto.fill();
   */

//	 contexto.lineTo(251,250);
	//  	 contexto.lineTo(10,100);
/*
      contexto.fill();
	  
	  contexto.beginPath();
	  contexto.moveTo(80,5);  // [1] en la imagen
 
// dibujo una línea hasta (115,10)
contexto.lineTo(115,10); // [2] en la imagen
 
// dibujo otra línea desde el último punto hasta (125,10)
contexto.lineTo(125,10);  // [3] en la imagen
 
// cierro el path, lo cual genera la última línea
contexto.closePath();
 
// lleno el path con el color negro
contexto.fill();

		}
	}
}
*/