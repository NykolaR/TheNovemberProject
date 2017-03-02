local Base = {}

local Book = require ("src.entity.interactable.book")
local Cacti = require ("src.entity.interactable.cacti")

Base.items = {}

Base.items [Book.oState] = Book
Base.items [Cacti.oState] = Cacti

return Base
