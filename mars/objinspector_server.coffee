isObject = (vl) ->
      if _.isObject(vl)
        not(_.isString(vl) or _.isNumber(vl) or _.isBoolean(vl) or _.isDate(vl) or _.isRegExp(vl))
      else
        false

getType = (vl) ->
  if _.isObject(vl) then /function\s*(.+)\s*\(/.exec(vl.constructor.toString())[1] else typeof(vl)

objectInfo = (ar) ->
  obj = if Meteor.isClient then window else global
  for i in ar
    break unless obj[i]?
    obj = obj[i]
  
  info = { p: [], f: [] }
  for itemName in _.keys(obj).sort()
    if _.has(obj, itemName)
      if _.isFunction(obj[itemName])
        info.f.push
          i: itemName
          v: obj[itemName].toString()
      else
        info.p.push
          i: itemName
          t: getType(obj[itemName])
          o: isObject(obj[itemName])
          v: if isObject(obj[itemName]) then undefined else "" + obj[itemName]

  info


Meteor.methods
  oiObjectInfo: (objectPath) ->         
    objectInfo(objectPath)