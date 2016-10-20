delta = 0.01;

wall_thickness = 4;
board_width = 50;
board_depth = 50;
board_thickness = 1.6;
usb_height = 3;
corner_radius = 3;

under_board_height = 5;
above_board_height = 7;

lip_height = 1;
lip_width = (wall_thickness / 2) - delta;

overall_width = board_width + (wall_thickness * 2);
overall_depth = board_depth + (wall_thickness * 2);
board_cavity_depth = under_board_height + board_thickness;
bottom_height = board_cavity_depth + wall_thickness;
top_cavity_depth = above_board_height;
top_height = top_cavity_depth + wall_thickness;

board_support_width = 9 + wall_thickness;
board_support_centers = [[((overall_width/2) - (board_support_width / 2)), ((overall_width/2) - (board_support_width / 2)), 0],
                         [((overall_width/2) - (board_support_width / 2)), -((overall_width/2) - (board_support_width / 2)), 0],
                         [-((overall_width/2) - (board_support_width / 2)), ((overall_width/2) - (board_support_width / 2)), 0],
                         [-((overall_width/2) - (board_support_width / 2)), -((overall_width/2) - (board_support_width / 2)), 0]];
board_support_center_adjustment_bottom = [0, 0, -(board_cavity_depth + board_thickness)/2 - delta];                         
board_support_center_adjustment_top = [0, 0, -(top_cavity_depth/2) +.25 - delta];
board_support_dimensions = [board_support_width, board_support_width, board_cavity_depth - (board_thickness / 2)];
board_support_dimensions_top = [board_support_width, board_support_width, top_cavity_depth + .5];
num_holes = 4;
hole_locations = [[-19.05, -19.05, 0], [19.05, 19.05, 0], [-19.05, 19.05, 0], [19.05, -19.05, 0]];

usb_port_width = 13;
usb_port_height = 11;
usb_port_radius = 2;
usb_port_z_offset = 1.5;

uart_port_width = 4.5;
uart_port_depth = 17.25;
uart_port_center = [20.32, 0, 0];

st_link_port_width = 4.5;
st_link_port_depth = 17.25;
st_link_port_center = [-17.78, 3.81, 0];

lpc_link_port_width = 4.5;
lpc_link_port_depth = 24.85;
lpc_link_port_center = [-21.59, 0, 0];

jtag_port_width = 33;
jtag_port_depth = 8.5;
jtag_port_center = [0, -10.16, 0];

swd_port_width = 13;
swd_port_inner_edge = 15.75;

translate([-50, 0, 0]) top_shell();
translate([50, 0, 0]) bottom_shell();

module top_shell() {
    difference() {
        union() {
            difference() {
                // main body
                miniroundsphere([overall_width, overall_depth, top_height * 2], corner_radius);
                // cut in half and excavate
                union() {
                    translate([0, 0, (top_height + delta)/2]) cube([overall_width + delta, overall_depth + delta, top_height + delta], center=true);
                    miniroundsphere([board_width, board_depth, 2*top_cavity_depth], 2);
                }
            }
            
            // board supports
            for(i=[0:3]) {
                translate(board_support_centers[i] + board_support_center_adjustment_top)                 miniroundcyl(board_support_dimensions_top, corner_radius);
            }
            
            // lip
            translate([0, 0, lip_height - delta]) difference() {
                miniroundcyl([overall_width, overall_depth, lip_height * 2], corner_radius);
                miniroundcyl([overall_width-(lip_width * 2), overall_depth-(lip_width * 2), lip_height * 2 + 2* delta], corner_radius * .95);
            }
        }
        
        
        // screw holes with nut traps
        for(i=[0:3]) {
            translate(hole_locations[i]+[0,0,-top_height])union() {
                //m3_nut_trap();
                translate([0,0,(top_height + delta) / 2]) cylinder(r=1.6, h=top_height + delta, center=true, $fn = 50);
            }
        }
        
        // USB port
        translate([0, overall_depth / 2, -usb_port_z_offset]) rotate([90,0,0]) miniroundcyl([usb_port_width, usb_port_height, overall_depth], usb_port_radius);
        
        // UART port
        translate(uart_port_center + [0, 0, -(top_height/2) - delta]) cube([uart_port_width, uart_port_depth, top_height], center=true);
        
        // STLink port
        translate(st_link_port_center + [0, 0, -(top_height/2) - delta]) cube([st_link_port_width, st_link_port_depth, top_height], center=true);
        
        // LPCLink port
        translate(lpc_link_port_center + [0, 0, -(top_height/2) - delta]) cube([lpc_link_port_width, lpc_link_port_depth, top_height], center=true);
        
        // JTAG port
        translate(jtag_port_center + [0, 0, -(top_height/2) - delta]) cube([jtag_port_width, jtag_port_depth, top_height], center=true);
        
        // SWD port
        
        translate([0, -(overall_depth/2) - swd_port_inner_edge, -(top_height/2) + delta]) cube([swd_port_width, overall_depth, top_height*2], center=true);
        
    } 
    
}

module bottom_shell() {
    difference() {
        union() {
            difference() {
                // main body
                miniroundsphere([overall_width, overall_depth, bottom_height * 2], corner_radius);
                // cut in half and excavate
                union() {
                    translate([0, 0, (bottom_height + delta)/2]) cube([overall_width + delta, overall_depth + delta, bottom_height + delta], center=true);
                    miniroundsphere([board_width, board_depth, 2*board_cavity_depth], 2);
                }
            }
            
            // board supports
            for(i=[0:3]) {
                translate(board_support_centers[i] + board_support_center_adjustment_bottom) miniroundcyl(board_support_dimensions, corner_radius);
            }
        }
        
        // lip
        difference() {
            miniroundcyl([overall_width+delta, overall_depth+delta, lip_height * 2], corner_radius);
            miniroundcyl([overall_width-(lip_width * 2), overall_depth-(lip_width * 2), lip_height * 2], corner_radius * .95);
        }
        
        // screw holes with nut traps
        for(i=[0:3]) {
            translate(hole_locations[i]+[0,0,-bottom_height])union() {
                m3_nut_trap();
                translate([0,0,(bottom_height + delta) / 2]) cylinder(r=1.6, h=bottom_height + delta, center=true, $fn = 50);
            }
        }
        
        // USB port
        translate([0, overall_depth / 2, usb_port_z_offset]) rotate([90,0,0]) miniroundcyl([usb_port_width, usb_port_height, overall_depth], usb_port_radius);
    }
}

module miniroundsphere(size, radius)
{
    $fn=50;
    x = size[0]-(2*radius);
    y = size[1]-(2*radius);
    z = size[2]-(2*radius);

    minkowski()
    {
        cube(size=[x,y,z], center=true);
        sphere(r=radius);
    }
}

module miniroundcyl(size, radius)
{
    $fn=50;
    x = size[0]-(2*radius);
    y = size[1]-(2*radius);
    z = size[2]-(radius/2);

    translate([0, 0, -radius/4]) minkowski()
    {
        cube(size=[x,y,z], center=true);
        cylinder(r=radius);
    }
}

module m3_nut_trap()
{
    translate([0,0,1.24]) cylinder(r = 5.5 / 2 / cos(180 / 6) + 0.05, h=2.5, center=true, $fn=6);
}