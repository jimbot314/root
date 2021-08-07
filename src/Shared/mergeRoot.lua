local function merge(tbl1, tbl2)
  for k,v in pairs(tbl2) do
    tbl1[k] = v
  end
end

return merge