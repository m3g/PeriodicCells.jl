module PeriodicCells

using Parameters
using StaticArrays
using DocStringExtensions

export Cell

"""

$(TYPEDEF)

Structure that contains the cell data. 

"""
@with_kw struct Cell{N,T}
  sides::SVector{N,T}
  angles::SVector{N,T}
  origin::SVector{N,T}
end

"""

```
function wrap!(x::AbstractVector, sides::AbstractVector, center::AbstractVector)
```

Functions that wrap the coordinates They modify the coordinates of the input vector.  
Wrap to a given center of coordinates

"""
function wrap!(x::AbstractVector, cell::Cell, center::AbstractVector)
  for i in eachindex(x)
    x[i] = wrapone(x[i],cell.sides,center)
  end
  return nothing
end

@inline function wrapone(x::AbstractVector, cell:Cell, center::AbstractVector)
  s = @. (x-center)%sides
  s = @. wrapx(s,sides) + center
  return s
end

@inline function wrapx(x,s)
  if x > s/2
    x = x - s
  elseif x < -s/2
    x = x + s
  end
  return x
end

"""

```
wrap!(x::AbstractVector, cell::Cell)
```

Wrap to origin (slightly cheaper).

"""
function wrap!(x::AbstractVector, cell::Cell)
  for i in eachindex(x)
    x[i] = wrapone(x[i],cell.sides)
  end
  return nothing
end

@inline function wrapone(x::AbstractVector, cell::Cell)
  s = @. x%sides
  s = @. wrapx(s,cell.sides)
  return s
end

end # module PeriodicCells
