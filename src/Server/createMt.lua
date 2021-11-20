return  function(ctx)
  return {
    __index = function(self, key)
      if (ctx[key]) then
        return ctx[key]
      else
        self[key] = self.Ref[key]
        return self.Ref[key]
      end
    end,
  }
end