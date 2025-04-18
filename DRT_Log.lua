DRT_Log = {
  isDebug = false
}

function DRT_Log:debug(msg)
  print(format('DRT: %s', msg))
end

function DRT_Log:error(msg)
  print(format('DRT |cFFD20103[ERROR]: %s|r', msg))
end
