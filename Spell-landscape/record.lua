

function record.save()
   local path = system.pathForFile( record.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( record.score )
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read ", record.filename, "." )
      return false
   end
end
function record.load()
   local path = system.pathForFile( record.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      return score
   else
      print( "Error: could not read scores from ", record.filename, "." )
   end
   return nil
end
return record