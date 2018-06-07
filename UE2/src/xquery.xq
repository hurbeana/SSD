<bigareas>
  {
    for $a in fn:doc("../resources/system-xsd.xml")//area[fn:count(./*) > 2]
    order by $a/@name
    return
      <area name="{$a/@name}">
        {
          for $s in $a/slot
          return
            if (fn:sum($s//cost) > 10) then
              <slot id="{$s/@id}">
                <time>
                  {
                    let $max := fn:max($s//time)
                    let $sum := fn:sum($s//time)
                    return
                      if ($s/@parallel) then
                        $max
                      else
                        $sum
                  }
                </time>
                <cost>{fn:sum($s//cost)}</cost>
              </slot>
            else ""
        }
      </area>
  }
</bigareas>