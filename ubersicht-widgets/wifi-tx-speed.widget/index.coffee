# WiFi Transmission Speed Widget
#
# Joe Kelley
#
# Unlike the little "signal strength" icon, this simple little widget tells you how fast your WiFi connection is actually communicating
# It uses the built-in OS X airport framework to get the actual transmission speed calculated using the most recent wireless network traffic
# It is particularly useful for finding the best place to position your computer and/or access point for best performance.

command: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep TxRate | cut -c 18-20"

refreshFrequency: 10000

# Adjust the style settings to suit. I've set the position to be just below the WiFi icon in my menu bar.

style: """
  top 23%
  left 3%
  font-family: Apple Kid
  color: #fff


  div
    display: block

    border-radius 5px
    text-shadow: 0 0 1px rgba(#000, 0.5)

    font-size: 30px
    font-weight: 400
    padding: 4px 6px 4px 6px



    &:after
      font-family: Apple Kid
      text_align: "right"
      position: absolute
      color: #fff
      left: 40px
      top: 0px
      font-size: 12px
      font-weight: 300

 img
    height: 24px
    width: 24px
    margin-bottom: -3px

"""

render: -> """
  <div><img src="wifi-tx-speed.widget/icon48.png">
   <a class='tx_speed'></a></div>
"""

update: (output) ->
	if(output)
  		$('.tx_speed').html(output + 'Mbps')
  	else
  		 $('.tx_speed').html(output + 'WiFi OFF')
