# 2D spring formula from http://www.myphysicslab.com/spring2d.html

dots = {}
  
mouse =
    position:
        x:0
        y:0
        
window.springL = 10
window.springConstant = 3

window.restLength  = 200

window.mass = 10
window.dampening = 5.0
window.gravity = 10          
        
window.nummber_of_dots = 20      

anchor_clicked = false

anchor = 
    position:
        x : Math.ceil Math.random() * $(document).width()
        y : Math.ceil Math.random() * $(document).height()
    size: 70
    color : "rgba(".concat(Math.round(Math.random()*255),",", Math.round(Math.random()*255),",",Math.round(Math.random()*255), ", 1)")

canvas

$ ->
    
    dots=for x in [0...window.nummber_of_dots]
        dot =
            anchor : false
            color : "rgba(".concat(Math.round(Math.random()*255),",", Math.round(Math.random()*255),",",Math.round(Math.random()*255), ", .75)")
            position:
                x : Math.ceil Math.random() * $(document).width()
                y : Math.ceil Math.random() * $(document).height()
            velocity:
                x :0
                y :0
            acceleration:
                x :0
                y :0  
              
    
    
    
    canvas = $("#canvas")[0]
    canvas.width= $(document).width()
    canvas.height=$(document).height()

    ctx = canvas.getContext("2d")
    ctx.fillStyle="#FF0000"
    ctx.fillRect 0,0,10,10
    setInterval draw,1000 / 60




$(canvas).mousemove((event) ->
    
    
    
    if anchor_clicked == true
        anchor.position.x = event.clientX
        anchor.position.y = event.clientY
)

$(canvas).mouseup((event) ->
    
    anchor_clicked = false
    anchor.size = 70
    
)

$(canvas).mousedown((event) ->

    if distance(anchor.position, {x:event.clientX,y:event.clientY}) < anchor.size
        anchor_clicked = true
        anchor.size = 80
        
    
)


    
    
checkCollision = (dotA,dotB) ->
    
    
    #if distance(dotA.position,dotB.position) < 40
    #    console.log "collision"
    false

distance = (positionA,positionB) ->
    
    Math.sqrt(Math.pow(positionA.x - positionB.x,2) +
              Math.pow(positionA.y - positionB.y,2))
    
    
    
    
addDot = ->
    

updateDots = ->
    if window.nummber_of_dots != dots.length
        if window.nummber_of_dots > dots.length
            new_dots=for x in [dots.length...window.nummber_of_dots]
                dot =
                    anchor : false
                    color : "rgba(".concat(Math.round(Math.random()*255),",", Math.round(Math.random()*255),",",Math.round(Math.random()*255), ", .75)")
                    position:
                        x : Math.ceil Math.random() * $(document).width()
                        y : Math.ceil Math.random() * $(document).height()
                    velocity:
                        x :0
                        y :0
                    acceleration:
                        x :0
                        y :0
                        
            
            dots = dots.concat new_dots,dots
            
        if window.nummber_of_dots < dots.length
            dots = dots.splice 0,window.nummber_of_dots
            
    
update = ->
    
    updateDots()
    
    for dot in dots
        sinO = (dot.position.x - anchor.position.x)/window.springL
        cosO = (dot.position.y - anchor.position.y)/window.springL
        if dot == undefined or anchor == undefined
            dist = 0
        else
            dist = distance dot.position,anchor.position
        springStretch = dist - window.restLength
        
        
    
        dot.acceleration.x = -(window.springConstant/window.mass) * springStretch * sinO - (window.dampening/window.mass) * dot.velocity.x
        dot.acceleration.y = window.gravity - (window.springConstant/window.mass) * springStretch * cosO - (window.dampening/window.mass) * dot.velocity.y
        
        dot.acceleration.x = returnValidNumber dot.acceleration.x
        dot.acceleration.y = returnValidNumber dot.acceleration.y
        
        
        dot.velocity.x +=  dot.acceleration.x * 0.01
        dot.velocity.y +=  dot.acceleration.y * 0.01
        
        
        
        dot.velocity.x = returnValidNumber dot.velocity.x
        dot.velocity.y = returnValidNumber dot.velocity.y
    
          
        dot.position.x += dot.velocity.x * 0.01
        dot.position.y += dot.velocity.y * 0.01    

        
        
                        

  returnValidNumber = (value) ->
  
    if !isFinite(value) || isNaN(value)
      value = 0
    
    value
  


draw = ->
    
    
    update()
    
    ctx = canvas.getContext '2d'
    ctx.clearRect 0,0,canvas.width,canvas.height
    for dot in dots
        ctx.beginPath()
        ctx.fillStyle = dot.color
        ctx.arc dot.position.x, dot.position.y, 40, 0, Math.PI*2, true
        ctx.fill()
        ctx.strokeStyle = dot.color

        ctx.moveTo dot.position.x,dot.position.y
        ctx.lineTo anchor.position.x,anchor.position.y
        ctx.stroke()        
        
        
    ctx.fillStyle = anchor.color
    ctx.beginPath()
    ctx.arc anchor.position.x, anchor.position.y, anchor.size, 0, Math.PI*2, true
    ctx.closePath()
    ctx.fill()
    
  
  
  