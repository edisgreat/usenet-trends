$(document).ready(function(){

  $('.expander').click(function(){
    var $this = $(this)
    if($this.attr('expanded') == 'true'){
      $this.attr('expanded','false')
      $this.html('(&plus;)')
      $(this).parents('.result').find('ul').addClass('closed')
    }else{
      $this.attr('expanded','true')
      $this.html('(&minus;)')
      $(this).parents('.result').find('ul').removeClass('closed')
    }
  })

  $('.advanced-clicker').click(function(){$('.advanced-holder').show()})


})