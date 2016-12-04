# You may exclude certain drives (separate with a pipe)
# Example: exclude = 'MyBook' or exclude = 'MyBook|WD Passport'
exclude   = 'NVProtectedEditingSpace'

# Use base 10 numbers, i.e. 1GB = 1000MB. Leave this true to show disk sizes as
# OS X would (since Snow Leopard)
base10       = true

# appearance
filledStyle  = false # set to true for the second style variant. bgColor will become the text color

width        = '360px'
barHeight    = '36px'
labelColor   = '#fff'
usedColor    = '#d7051d'
freeColor    = '#525252'
bgColor      = '#fff'
borderRadius = '3px'
bgOpacity    = 0.9

# You may optionally limit the number of disk to show
maxDisks: 5

command: "df -#{if base10 then 'H' else 'h'} | grep '/dev/' | while read -r line; do fs=$(echo $line | awk '{print $1}'); name=$(diskutil info $fs | grep 'Volume Name' | awk '{print substr($0, index($0,$3))}'); echo $(echo $line | awk '{print $2, $3, $4, $5}') $(echo $name | awk '{print substr($0, index($0,$1))}'); done | grep -vE '#{exclude}'"

refreshFrequency: 20000

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  // Statistics text settings
  color #fff
  font-family: Apple Kid
  top 33%
  left 3%
  font-family: Apple Kid
  color: #fff

    table
      border-collapse: collapse
      table-layout: fixed

      &:after
        content: 'DISKS'
        position: absolute
        left: 0
        top: -14px
        font-size 14px
        text-transform uppercase
        font-weight bold

    td
      font-size: 26px
      font-weight: 100
      width: 120px
      max-width: 120px
      overflow: hidden
      text-shadow: 0 0 1px rgba(#000, 0.5)

    .wrapper
      position: relative

    p
      padding: 5px
      margin: 0
      font-size: 20px
      font-weight: normal
      max-width: 100%
      color: #ddd
      text-overflow: ellipsis
      text-shadow: none

    .pid
      position: absolute
      top: 2px
      right: 2px
      padding-right: 2px
      font-size: 12px
      font-weight: normal

  .container
    width: 360px
    text-align: widget-align
    position: relative
    clear: both

  .container:not(:first-child)
    margin-top: 20px

  .widget-title
    text-align: widget-align

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td.pctg
    float: right

  .widget-title, p
    font-size 18px
    text-transform uppercase
    font-weight bold

  .label
    font-size 18px
    text-transform uppercase
    font-weight bold

  .bar-container
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    background: rgba(#fff, .5)
    position: absolute
    margin-bottom: 5px

  .bar
    height: bar-height
    float: widget-align
    transition: width .2s ease-in-out

  .bar:first-child
    if widget-align == left
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar:last-child
    if widget-align == right
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar-used
    background: rgba(#c00, .5)
"""

humanize: (sizeString) ->
  sizeString + 'B'


renderInfo: (total, used, free, pctg, name) -> """
  <div class="container">
    <div class="widget-title">#{name} #{@humanize(total)}</div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="stat"><span class="used">#{@humanize(used)}</span></td>
        <td class="stat"><span class="free">#{@humanize(free)}</span></td>
        <td class="stat pctg"><span class="pctg">#{pctg}</span></td>
      </tr>
      <tr>
        <td class="label">used</td>
        <td class="label">free</td>
        <td class="label pctg">pctg</td>
      </tr>
    </table>
    <div class="bar-container">
      <div class="bar bar-used" style="width: #{pctg}"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  $(domEl).html ''

  for disk, i in disks[..(@maxDisks - 1)]
    args = disk.split(' ')
    if (args[4])
      args[4] = args[4..].join(' ')
      $(domEl).append @renderInfo(args...)

  $(domEl).append ''
