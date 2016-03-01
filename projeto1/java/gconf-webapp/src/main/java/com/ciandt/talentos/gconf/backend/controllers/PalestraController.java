package com.ciandt.talentos.gconf.backend.controllers;


import java.util.List;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.ciandt.talentos.gconf.backend.dto.PalestraDTO;
import com.ciandt.talentos.gconf.backend.entities.Palestra;
import com.ciandt.talentos.gconf.backend.services.PalestraService;

@Controller
public class PalestraController {

	private final Logger log = Logger.getLogger(this.getClass());
	
	@Autowired
	private PalestraService palestraService;

    @ResponseBody
    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(value="/palestras/search", method = RequestMethod.GET)
    public List<PalestraDTO> searchPalestrasByQuery(
    		@RequestParam(value = "titulo", required = false) String titulo,
    		@RequestParam(value = "palestrante_id", required = false) Long palestranteId) {
    	
    	log.info("buscar Palestras por filtro:"
    			+ " titulo= " + titulo
    			+ " palestrante= " + palestranteId);
    	
    	List<Palestra> palestras = palestraService.
    			findPalestrasByTituloAndPalestranteIdNoRequered(titulo, palestranteId);
    	    	
    	return palestras.stream()
    			.map(palestra -> new PalestraDTO(palestra))
    			.collect(Collectors.toList()); 
   }


}
