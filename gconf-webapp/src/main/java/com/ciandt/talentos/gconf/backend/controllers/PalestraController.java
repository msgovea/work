package com.ciandt.talentos.gconf.backend.controllers;


import java.util.List;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
    @RequestMapping(value="/palestras/titulo/{titulo}", method = RequestMethod.GET)
    public List<PalestraDTO> searchPalestrasByTitulo(@PathVariable(value = "titulo") String titulo) {
    	
    	log.info("buscar Palestras por Titulo: " + titulo);
    	List<Palestra> palestras = palestraService.findPalestrasByTitulo(titulo);
    	    	
    	return palestras.stream()
    			.map(palestra -> new PalestraDTO(palestra))
    			.collect(Collectors.toList()); 
   }


}
