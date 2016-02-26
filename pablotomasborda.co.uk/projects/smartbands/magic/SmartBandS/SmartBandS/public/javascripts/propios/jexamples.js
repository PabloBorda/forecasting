/*
Berlin Sans FB Demi Font 36

$(document).ready(function() {
   $('div').mouseenter(function() {             --> Cuando posiciona el puntero arriba del div
       $(this).animate({                        --> Eleva 10 px 
           height: '+=10px'
       });
   });
   $('div').mouseleave(function() {
       $(this).animate({                       --> Cuando deja de posicionar el puntero arriba del div
           height: '-=10px'                    -->  Baja 10 px
       }); 
   });
   $('div').click(function() {
       $(this).toggle(1000);                   --> Reduce hasta eliminar el div
   }); 
  
});

*/