-------------------------------------------------------------
-- ALREADY RUN
-------------------------------------------------------------



ALTER FUNCTION checkemu_whole_country SET SCHEMA datawg;
ALTER TABLE datawg.t_eelstock_eel DROP CONSTRAINT ck_emu_whole_aquaculture;

/*
 * 
--- works but not as a check, replaced with a trigger
SELECT * FROM datawg.t_eelstock_eel
WHERE eel_qal_id =1
AND eel_typ_id = 11 
AND NOT datawg.checkemu_whole_country(eel_emu_nameshort::text);
 */



CREATE OR REPLACE FUNCTION datawg.checkemu_whole_country()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
DECLARE nberror INTEGER ;
BEGIN
SELECT COUNT(*) INTO nberror 
FROM NEW JOIN   ref.tr_emu_emu
ON tr_emu_emu.emu_nameshort = NEW.emu_nameshort
WHERE NEW.eel_qal_id =1 AND 
NEW.eel_typ_id = 11 AND NOT emu_wholecountry ;
IF (nberror > 0) THEN
      RAISE EXCEPTION 'Aquaculture must be applied to an emu where emu_wholecountry = TRUE' ;
END IF  ;
RETURN NEW ;
END  ;
$function$
;


CREATE TRIGGER trg_check_emu_whole_aquaculture AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION checkemu_whole_country();



--we add a column to store identifiers from national database so that data providers
--can easily find their fishes
alter table datawg.t_fishsamp_fisa add column fi_idcou varchar(50);


--avoid recursive triggers fires
drop trigger update_coordinates on datawg.t_series_ser ;
create trigger update_coordinates after
update
    of geom on
    datawg.t_series_ser for each row WHEN (pg_trigger_depth() < 1) execute function datawg.update_coordinates();

drop trigger update_geom on datawg.t_series_ser;
create trigger update_geom after
insert
    or
update
    of ser_x,
    ser_y on
    datawg.t_series_ser for each row WHEN (pg_trigger_depth() < 1) execute function datawg.update_geom();


update ref.tr_gear_gea set gea_issscfg_code='01.9' where gea_name_en='Surrounding nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='10.9' where gea_name_en='Gear nei';
update ref.tr_gear_gea set gea_issscfg_code='01.2' where gea_name_en='Surrounding nets without purse lines';
update ref.tr_gear_gea set gea_issscfg_code='02.1' where gea_name_en='Beach seines';
update ref.tr_gear_gea set gea_issscfg_code='02.2' where gea_name_en='Boat seines';
update ref.tr_gear_gea set gea_issscfg_code='02.9' where gea_name_en='Seine nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='03.19' where gea_name_en='Bottom trawls (nei)';
update ref.tr_gear_gea set gea_issscfg_code='03.13' where gea_name_en='Twin bottom otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.14' where gea_name_en='Multiple bottom otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.3' where gea_name_en='Semipelagic trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.9' where gea_name_en='Trawls (nei)';
update ref.tr_gear_gea set gea_issscfg_code='04.1' where gea_name_en='Towed dredges';
update ref.tr_gear_gea set gea_issscfg_code='04.2' where gea_name_en='Hand dredges';
update ref.tr_gear_gea set gea_issscfg_code='05.1' where gea_name_en='Portable lift nets';
update ref.tr_gear_gea set gea_issscfg_code='05.2' where gea_name_en='Boat-operated lift nets';
update ref.tr_gear_gea set gea_issscfg_code='05.9' where gea_name_en='Lift nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='06.1' where gea_name_en='Cast nets';
update ref.tr_gear_gea set gea_issscfg_code='06.2' where gea_name_en='Cover pots/Lantern nets';
update ref.tr_gear_gea set gea_issscfg_code='07.1' where gea_name_en='Set gillnets (anchored)';
update ref.tr_gear_gea set gea_issscfg_code='07.2' where gea_name_en='Drift gillnets';
update ref.tr_gear_gea set gea_issscfg_code='07.3' where gea_name_en='Encircling gillnets';
update ref.tr_gear_gea set gea_issscfg_code='07.5' where gea_name_en='Trammel nets';
update ref.tr_gear_gea set gea_issscfg_code='07.9' where gea_name_en='Gillnets and entangling nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='08.2' where gea_name_en='Pots';
update ref.tr_gear_gea set gea_issscfg_code='08.3' where gea_name_en='Fyke nets';
update ref.tr_gear_gea set gea_issscfg_code='08.4' where gea_name_en='Stow nets';
update ref.tr_gear_gea set gea_issscfg_code='08.5' where gea_name_en='Barriers, fences, weirs, etc.';
update ref.tr_gear_gea set gea_issscfg_code='08.6' where gea_name_en='Aerial traps';
update ref.tr_gear_gea set gea_issscfg_code='08.9' where gea_name_en='Traps (nei)';
update ref.tr_gear_gea set gea_issscfg_code='09.4' where gea_name_en='Vertical lines';
update ref.tr_gear_gea set gea_issscfg_code='09.31' where gea_name_en='Set longlines';
update ref.tr_gear_gea set gea_issscfg_code='09.32' where gea_name_en='Drifting longlines';
update ref.tr_gear_gea set gea_issscfg_code='09.39' where gea_name_en='Longlines (nei)';
update ref.tr_gear_gea set gea_issscfg_code='09.5' where gea_name_en='Trolling lines';
update ref.tr_gear_gea set gea_issscfg_code='09.9' where gea_name_en='Hooks and lines (nei)';
update ref.tr_gear_gea set gea_issscfg_code='10.1' where gea_name_en='Harpoons';
update ref.tr_gear_gea set gea_issscfg_code='10.3' where gea_name_en='Pumps';
update ref.tr_gear_gea set gea_issscfg_code='04.3' where gea_name_en='Mechanized dredges';
update ref.tr_gear_gea set gea_issscfg_code='04.9' where gea_name_en='Dredges (nei)';
update ref.tr_gear_gea set gea_issscfg_code='10.4' where gea_name_en='Electric fishing';
update ref.tr_gear_gea set gea_issscfg_code='99.9' where gea_name_en='Gear not known';
update ref.tr_gear_gea set gea_issscfg_code='08.1' where gea_name_en='Stationary uncovered pound nets';
update ref.tr_gear_gea set gea_issscfg_code='07.4' where gea_name_en='Fixed gillnets (on stakes)';
update ref.tr_gear_gea set gea_issscfg_code='09.1' where gea_name_en='Handlines and hand-operated pole-and-lines';
update ref.tr_gear_gea set gea_issscfg_code='01.1' where gea_name_en='Purse seines';
update ref.tr_gear_gea set gea_issscfg_code='07.6' where gea_name_en='Combined gillnets-trammel nets';
update ref.tr_gear_gea set gea_issscfg_code='10.5' where gea_name_en='Pushnets';
update ref.tr_gear_gea set gea_issscfg_code='10.6' where gea_name_en='Scoopnets';
update ref.tr_gear_gea set gea_issscfg_code='05.3' where gea_name_en='Shore-operated stationary lift nets';
update ref.tr_gear_gea set gea_issscfg_code='03.11' where gea_name_en='Beam trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.12' where gea_name_en='Single boat bottom otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.15' where gea_name_en='Bottom pair trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.21' where gea_name_en='Single boat midwater otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.22' where gea_name_en='Midwater pair trawls';
update ref.tr_gear_gea set gea_issscfg_code='09.2' where gea_name_en='Mechanized lines and pole-and-lines';
update ref.tr_gear_gea set gea_issscfg_code='10.2' where gea_name_en='Hand Implements (Wrenching gear, Clamps, Tongs, Rakes, Spears)';
update ref.tr_gear_gea set gea_issscfg_code='10.7' where gea_name_en='Drive-in nets';
update ref.tr_gear_gea set gea_issscfg_code='10.8' where gea_name_en='Diving';
update ref.tr_gear_gea set gea_issscfg_code='03.29' where gea_name_en='Midwater trawls (nei)';
update ref.tr_gear_gea set gea_issscfg_code='06.9' where gea_name_en='Falling gear (nei)';


--creation of the datasource
insert into ref.tr_datasource_dts values ('dc_2023', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2023');

insert into ref.tr_quality_qal values (23, 'discarded_wgeel 2023','This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2023', FALSE);
    
-------------------------------------------------------------
-- TO BE RUN BEFORE GENERATING THE TEMPLATES
-------------------------------------------------------------

    