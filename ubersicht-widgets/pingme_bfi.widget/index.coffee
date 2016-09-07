#The site to monitor
site = 'bfi.uchicago.edu'


command: "ping -c 10 -q #{site}"

refreshFrequency: 20000

style: """
    left: 40%
    top: 3%
    font-family: Apple Kid
    color: #fff

    .time
        font-size: 42px
        text-align: left

    .site
        font-size: 21px
        text-align: right
        color: rgba(#fff, 0.5)
"""

render: -> """
<div id="response">
    <div class="time"><span class="timeval"></span>ms</div>
    <div class="site"></div>
</div
"""
#.*round.*\=.*\/(.*).*\/.*\/
update: (output, domEl) ->
    $container = $(domEl).find '#response'
    avg = Math.round((/.*round.*\=.*\/([0-9.]*).*\/.*\/.*ms/.exec(output))[1])
    site = (/PING(.*)\(/.exec(output))[1]
    $('.timeval').text avg
    $('.site').text site
