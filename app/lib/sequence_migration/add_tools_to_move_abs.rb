module SequenceMigration
  # Background:
  # When this migration was created, the move_absolute block could only move to
  # a fixed point on the map.
  # After this migration, the user could move to a dynamically set tool location
  # -OR- a fixed point on the map. It also added an "offset" property for tools
  # with funny sizes.
  class AddToolsToMoveAbs < Base
    VERSION = 2
    CREATED_ON = "DECEMBER 19 2016"

    def up
      sequence
        .body
        .select { |x| x["kind"] == "move_absolute" }
        .each   do |x|
          loc = { "kind" => "coordinate" }.merge(x["args"].slice("x", "y", "z"))
          x["args"]["location"] = loc
          x["args"].except!("x", "y", "z")
          x["args"]["offset"] = {
            "kind" => "coordinate",
            "args" => {
              "x" => 0,
              "y" => 0,
              "z" => 0
            }
          }

        end
    end
  end
end
