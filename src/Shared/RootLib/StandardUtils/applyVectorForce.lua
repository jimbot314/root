local applyVectorForce = {}

function applyVectorForce:Main(self, propsList, forceMagnitude)
	forceMagnitude = forceMagnitude or 3000
	self:forEach(propsList, function(props)
		local part = props.Part
		if (part) then
			local force = props.Direction.Unit * forceMagnitude
			local attachment = self:newInstance("Attachment",
				{
					Position = props.AttachmentPosition,
					Orientation = part.Orientation,
					Parent = part
				}
			)
			local vectorForce = self:newInstance("VectorForce",
				{
					Force = force,
					Attachment0 = attachment,
					RelativeTo = Enum.ActuatorRelativeTo.World,
					Parent = part
				}
			)
			--self.RunService.Heartbeat:task.wait()
			task.wait(0.1)

			attachment:Destroy()
			vectorForce:Destroy()
		end
	end, true)
end

return applyVectorForce
