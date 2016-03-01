package com.ciandt.talentos.gconf.backend.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

@Entity
@Table(name = "GC_PALESTRA")
public class Palestra {
	
	@Id
	@SequenceGenerator(name="GC_PALESTRA_SEQ")
	@Column(name="ID", nullable=false)
	private Long id;
	
	@ManyToOne
	@JoinColumn(name="PALESTRANTE_ID")
	private Palestrante palestrante;
	
	@Column(name="TITULO", nullable=false)
	private String titulo;
	
	@Column(name="RESUMO", nullable=false)
	private String resumo;
	
	public enum TipoPalestra {
		KEYNOTE(0), TRACK(1);
		
		private Integer value;
		
		TipoPalestra(Integer value) { this.value = value; }
		public Integer getValue() { return this.value; }
	};

	@Enumerated(EnumType.ORDINAL)
	@Column(name="TIPO_PALESTRA", nullable=false, length=1)
	private TipoPalestra tipoPatestra;

	public Palestra() {};
	
	public Palestra(Long id, String titulo, String resumo, TipoPalestra tipoPatestra, Palestrante palestrante) {
		this.id = id;
		this.titulo = titulo;
		this.resumo = resumo;
		this.tipoPatestra = tipoPatestra;
		this.palestrante = palestrante;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Palestrante getPalestrante() {
		return palestrante;
	}

	public void setPalestrante(Palestrante palestrante) {
		this.palestrante = palestrante;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getResumo() {
		return resumo;
	}

	public void setResumo(String resuno) {
		this.resumo = resuno;
	}

	public TipoPalestra getTipoPatestra() {
		return tipoPatestra;
	}

	public void setTipoPatestra(TipoPalestra tipoPatestra) {
		this.tipoPatestra = tipoPatestra;
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder()
				.append(this.getId())
				.toHashCode();
	}

	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Palestra)) {
			return false;
		}
		return new EqualsBuilder()
				.append(this.getId(), ((Palestra) o).getId())
				.isEquals();
	}	
	
	
	
	
}
