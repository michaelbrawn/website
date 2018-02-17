$ ->
  'use strict'
  # Start of use strict
  # Smooth scrolling using jQuery easing
  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click ->
    if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//, '') and location.hostname == @hostname
      target = $(@hash)
      target = if target.length then target else $('[name=' + @hash.slice(1) + ']')
      if target.length
        $('html, body').animate { scrollTop: target.offset().top - 54 }, 1000, 'easeInOutExpo'
        return false
  # Closes responsive menu when a scroll trigger link is clicked
  $('.js-scroll-trigger').click ->
    $('.navbar-collapse').collapse 'hide'
  # Activate scrollspy to add active class to navbar items on scroll
  $('body').scrollspy
    target: '#mainNav'
    offset: 56
  # Collapse Navbar

  navbarCollapse = ->
    if $('#mainNav').offset().top > 100
      $('#mainNav').addClass 'navbar-shrink'
    else
      $('#mainNav').removeClass 'navbar-shrink'

  # Collapse now if page is not at top
  navbarCollapse()
  # Collapse the navbar when page is scrolled
  $(window).scroll navbarCollapse
  # Hide navbar when modals trigger
  $('.portfolio-modal').on 'show.bs.modal', (e) ->
    $('.navbar').addClass 'd-none'
  $('.portfolio-modal').on 'hidden.bs.modal', (e) ->
    $('.navbar').removeClass 'd-none'

  # Contact Me
  $('#contactForm input,#contactForm textarea').jqBootstrapValidation
    preventSubmit: true
    submitError: ($form, event, errors) ->
      # additional error messages or events
    submitSuccess: ($form, event) ->
      event.preventDefault()
      # prevent default submit behaviour
      # get values from FORM
      name = $('input#name').val()
      email = $('input#email').val()
      phone = $('input#phone').val()
      message = $('textarea#message').val()
      firstName = name
      # For Success/Failure Message
      # Check for white space in name for Success/Fail message
      if firstName.indexOf(' ') >= 0
        firstName = name.split(' ').slice(0, -1).join(' ')
      $this = $('#sendMessageButton')
      $this.prop 'disabled', true
      # Disable submit button until AJAX call is complete to prevent duplicate messages
      $.ajax
        url: '././mail/contact_me.php'
        type: 'POST'
        data:
          name: name
          phone: phone
          email: email
          message: message
        cache: false
        success: ->
          # Success message
          $('#success').html '<div class=\'alert alert-success\'>'
          $('#success > .alert-success').html('<button type=\'button\' class=\'close\' data-dismiss=\'alert\' aria-hidden=\'true\'>&times;').append '</button>'
          $('#success > .alert-success').append '<strong>Your message has been sent. </strong>'
          $('#success > .alert-success').append '</div>'
          #clear all fields
          $('#contactForm').trigger 'reset'
        error: ->
            # Fail message
          $('#success').html '<div class=\'alert alert-danger\'>'
          $('#success > .alert-danger').html('<button type=\'button\' class=\'close\' data-dismiss=\'alert\' aria-hidden=\'true\'>&times;').append '</button>'
          $('#success > .alert-danger').append $('<strong>').text('Sorry ' + firstName + ', it seems that my mail server is not responding. Please try again later!')
          $('#success > .alert-danger').append '</div>'
          #clear all fields
          $('#contactForm').trigger 'reset'
        complete: ->
          setTimeout (->
            # Re-enable submit button when AJAX call is complete
            $this.prop 'disabled', false
            ), 1000
      filter: ->
        $(this).is ':visible'
  $('a[data-toggle="tab"]').click (e) ->
    e.preventDefault()
    $(this).tab 'show'

  ### When clicking on Full hide fail/success boxes ###
  $('#name').focus ->
    $('#success').html ''
